import argparse
import zipfile
import os
import io
from PIL import Image

def extract_from_docx(docx_path, class_name, output_dir):
    os.makedirs(output_dir, exist_ok=True)
    
    extracted = 0
    converted = 0
    skipped = 0
    
    skipped_log = open("skipped_files.txt", "a")
    
    if not os.path.exists(docx_path):
        print(f"Error: Could not find {docx_path}")
        return
        
    try:
        with zipfile.ZipFile(docx_path, 'r') as docx:
            for item in docx.namelist():
                if item.startswith('word/media/'):
                    filename = os.path.basename(item)
                    if not filename:
                        continue
                        
                    ext = filename.split('.')[-1].lower()
                    img_data = docx.read(item)
                    
                    if ext in ['jpeg', 'jpg', 'png']:
                        out_path = os.path.join(output_dir, filename)
                        with open(out_path, 'wb') as f:
                            f.write(img_data)
                        extracted += 1
                    elif ext == 'wdp':
                        # Try to convert WDP
                        out_path = os.path.join(output_dir, filename.replace('.wdp', '.png').replace('.WDP', '.png'))
                        success = False
                        try:
                            # Try Pillow
                            Image.open(io.BytesIO(img_data)).save(out_path, 'PNG')
                            converted += 1
                            success = True
                        except Exception as e:
                            try:
                                # Try wand
                                from wand.image import Image as WandImage
                                with WandImage(blob=img_data) as img:
                                    img.format = 'png'
                                    img.save(filename=out_path)
                                converted += 1
                                success = True
                            except Exception as e2:
                                pass
                        
                        if not success:
                            skipped_log.write(f"{docx_path} - {filename}\n")
                            skipped += 1
                    else:
                        out_path = os.path.join(output_dir, filename)
                        with open(out_path, 'wb') as f:
                            f.write(img_data)
                        extracted += 1
    except Exception as e:
        print(f"Error processing {docx_path}: {e}")
        
    skipped_log.close()
    print(f"[{class_name}] Extracted: {extracted}, Converted (.wdp): {converted}, Skipped: {skipped}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--positive", required=True, help="Path to positive docx")
    parser.add_argument("--negative", required=True, help="Path to negative docx")
    args = parser.parse_args()
    
    # Clear skipped_files.txt if it exists
    if os.path.exists("skipped_files.txt"):
        os.remove("skipped_files.txt")
        
    extract_from_docx(args.positive, "positive", "./dataset/positive/")
    extract_from_docx(args.negative, "negative", "./dataset/negative/")
