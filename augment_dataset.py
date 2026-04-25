import os
import cv2
import albumentations as A
import glob
import numpy as np

def balance_classes(pos_dir, neg_dir):
    pos_images_all = glob.glob(os.path.join(pos_dir, "*.*"))
    neg_images_all = glob.glob(os.path.join(neg_dir, "*.*"))
    
    pos_originals = [p for p in pos_images_all if "_aug" not in p]
    neg_originals = [p for p in neg_images_all if "_aug" not in p]
    
    print(f"Initial extraction counts - Positive: {len(pos_originals)}, Negative: {len(neg_originals)}")
    
    target_count = 343
    
    transforms = [
        A.HorizontalFlip(p=1.0),
        A.VerticalFlip(p=1.0),
        A.Rotate(limit=(15, 15), p=1.0),
        A.Rotate(limit=(-15, -15), p=1.0),
        A.RandomBrightnessContrast(brightness_limit=(0.2, 0.2), contrast_limit=0, p=1.0),
        A.RandomBrightnessContrast(brightness_limit=(-0.2, -0.2), contrast_limit=0, p=1.0),
        A.GaussNoise(var_limit=(26.0, 26.0), mean=0, p=1.0), 
    ]
    
    def augment_class(class_dir, original_images, current_count, target):
        idx = 0
        img_idx = 0
        transform_idx = 0
        
        while current_count < target:
            img_path = original_images[img_idx % len(original_images)]
            img = cv2.imread(img_path)
            if img is None:
                img_idx += 1
                continue
            
            img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
            
            if transform_idx < 7:
                augmented = transforms[transform_idx](image=img)['image']
            else:
                h, w = img.shape[:2]
                crop_h, crop_w = int(h * 0.9), int(w * 0.9)
                start_y = np.random.randint(0, max(1, h - crop_h + 1))
                start_x = np.random.randint(0, max(1, w - crop_w + 1))
                cropped = img[start_y:start_y+crop_h, start_x:start_x+crop_w]
                augmented = cv2.resize(cropped, (224, 224))
                
            aug_bgr = cv2.cvtColor(augmented, cv2.COLOR_RGB2BGR)
            
            base_name = os.path.splitext(os.path.basename(img_path))[0]
            ext = os.path.splitext(img_path)[1]
            out_name = f"{base_name}_aug_new_{idx}{ext}"
            cv2.imwrite(os.path.join(class_dir, out_name), aug_bgr)
            
            current_count += 1
            idx += 1
            
            transform_idx += 1
            if transform_idx > 7:
                transform_idx = 0
                img_idx += 1

    n_neg_current = len(glob.glob(os.path.join(neg_dir, "*.*")))
    if n_neg_current < target_count:
        augment_class(neg_dir, neg_originals, n_neg_current, target_count)
        
    n_pos_current = len(glob.glob(os.path.join(pos_dir, "*.*")))
    
    augment_class(pos_dir, pos_originals, n_pos_current, target_count)
    
    final_pos = len(glob.glob(os.path.join(pos_dir, "*.*")))
    final_neg = len(glob.glob(os.path.join(neg_dir, "*.*")))
    
    print(f"Final counts - Positive: {final_pos}, Negative: {final_neg}")
    if final_pos == final_neg:
        print("Confirmation: Both classes are equal.")

if __name__ == "__main__":
    balance_classes("./dataset/positive/", "./dataset/negative/")
