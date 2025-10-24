#!/usr/bin/env python3
"""
Create Google Play Store assets for Sudoku by Perfeasy Games
"""

from PIL import Image, ImageDraw, ImageFont
import os

# Create assets directory
os.makedirs("playstore_assets", exist_ok=True)

# Color scheme
CYAN = (0, 255, 255)      # #00FFFF
GREEN = (0, 255, 0)       # #00FF00
DARK = (26, 26, 26)       # #1a1a1a
WHITE = (255, 255, 255)   # #FFFFFF
PURPLE = (128, 0, 255)    # #8000FF

def create_app_icon():
    """Create 512x512 app icon"""
    size = 512
    img = Image.new('RGB', (size, size), DARK)
    draw = ImageDraw.Draw(img)
    
    # Create gradient background
    for y in range(size):
        color_ratio = y / size
        r = int(DARK[0] + (CYAN[0] - DARK[0]) * color_ratio * 0.3)
        g = int(DARK[1] + (CYAN[1] - DARK[1]) * color_ratio * 0.3)
        b = int(DARK[2] + (CYAN[2] - DARK[2]) * color_ratio * 0.3)
        draw.line([(0, y), (size, y)], fill=(r, g, b))
    
    # Draw Sudoku grid (9x9)
    grid_size = 300
    start_x = (size - grid_size) // 2
    start_y = 80
    
    # Grid lines
    cell_size = grid_size // 9
    for i in range(10):
        x = start_x + i * cell_size
        y = start_y + i * cell_size
        
        # Thick lines for 3x3 boxes
        line_width = 3 if i % 3 == 0 else 1
        draw.line([(x, start_y), (x, start_y + grid_size)], fill=CYAN, width=line_width)
        draw.line([(start_x, y), (start_x + grid_size, y)], fill=CYAN, width=line_width)
    
    # Add some sample numbers
    try:
        font = ImageFont.truetype("arial.ttf", 20)
    except:
        font = ImageFont.load_default()
    
    sample_numbers = [
        [5, 3, 0, 0, 7, 0, 0, 0, 0],
        [6, 0, 0, 1, 9, 5, 0, 0, 0],
        [0, 9, 8, 0, 0, 0, 0, 6, 0],
    ]
    
    for row in range(3):
        for col in range(9):
            if sample_numbers[row][col] != 0:
                x = start_x + col * cell_size + cell_size // 2
                y = start_y + row * cell_size + cell_size // 2
                draw.text((x-8, y-8), str(sample_numbers[row][col]), fill=WHITE, font=font)
    
    # Add "Perfeasy Games" text at bottom
    try:
        title_font = ImageFont.truetype("arial.ttf", 24)
        subtitle_font = ImageFont.truetype("arial.ttf", 16)
    except:
        title_font = ImageFont.load_default()
        subtitle_font = ImageFont.load_default()
    
    # Title
    title_text = "Perfeasy Games"
    title_bbox = draw.textbbox((0, 0), title_text, font=title_font)
    title_width = title_bbox[2] - title_bbox[0]
    title_x = (size - title_width) // 2
    draw.text((title_x, 420), title_text, fill=CYAN, font=title_font)
    
    # Subtitle
    subtitle_text = "Proudly Indian"
    subtitle_bbox = draw.textbbox((0, 0), subtitle_text, font=subtitle_font)
    subtitle_width = subtitle_bbox[2] - subtitle_bbox[0]
    subtitle_x = (size - subtitle_width) // 2
    draw.text((subtitle_x, 450), subtitle_text, fill=GREEN, font=subtitle_font)
    
    # Add glow effect
    glow_img = img.copy()
    for _ in range(3):
        glow_img = glow_img.filter(ImageFilter.GaussianBlur(radius=2))
    
    # Save
    img.save("playstore_assets/app_icon_512.png")
    print("✅ Created app_icon_512.png")

def create_feature_graphic():
    """Create 1024x500 feature graphic"""
    width, height = 1024, 500
    img = Image.new('RGB', (width, height), DARK)
    draw = ImageDraw.Draw(img)
    
    # Create gradient background
    for y in range(height):
        color_ratio = y / height
        r = int(DARK[0] + (CYAN[0] - DARK[0]) * color_ratio * 0.2)
        g = int(DARK[1] + (CYAN[1] - DARK[1]) * color_ratio * 0.2)
        b = int(DARK[2] + (CYAN[2] - DARK[2]) * color_ratio * 0.2)
        draw.line([(0, y), (width, y)], fill=(r, g, b))
    
    # Left side: Sudoku grid
    grid_size = 300
    start_x = 50
    start_y = (height - grid_size) // 2
    
    # Draw grid
    cell_size = grid_size // 9
    for i in range(10):
        x = start_x + i * cell_size
        y = start_y + i * cell_size
        
        line_width = 3 if i % 3 == 0 else 1
        draw.line([(x, start_y), (x, start_y + grid_size)], fill=CYAN, width=line_width)
        draw.line([(start_x, y), (start_x + grid_size, y)], fill=CYAN, width=line_width)
    
    # Add some numbers
    try:
        font = ImageFont.truetype("arial.ttf", 16)
    except:
        font = ImageFont.load_default()
    
    sample_numbers = [
        [5, 3, 0, 0, 7, 0, 0, 0, 0],
        [6, 0, 0, 1, 9, 5, 0, 0, 0],
        [0, 9, 8, 0, 0, 0, 0, 6, 0],
    ]
    
    for row in range(3):
        for col in range(9):
            if sample_numbers[row][col] != 0:
                x = start_x + col * cell_size + cell_size // 2
                y = start_y + row * cell_size + cell_size // 2
                draw.text((x-6, y-6), str(sample_numbers[row][col]), fill=WHITE, font=font)
    
    # Right side: Text content
    text_start_x = 450
    
    try:
        title_font = ImageFont.truetype("arial.ttf", 48)
        subtitle_font = ImageFont.truetype("arial.ttf", 24)
        tagline_font = ImageFont.truetype("arial.ttf", 20)
    except:
        title_font = ImageFont.load_default()
        subtitle_font = ImageFont.load_default()
        tagline_font = ImageFont.load_default()
    
    # Main title
    draw.text((text_start_x, 150), "Sudoku by", fill=CYAN, font=title_font)
    draw.text((text_start_x, 200), "Perfeasy Games", fill=CYAN, font=title_font)
    
    # Subtitle
    draw.text((text_start_x, 280), "Proudly Indian", fill=GREEN, font=subtitle_font)
    
    # Tagline
    draw.text((text_start_x, 320), "Master the grid. Challenge your mind.", fill=WHITE, font=tagline_font)
    
    # Save
    img.save("playstore_assets/feature_graphic_1024x500.png")
    print("✅ Created feature_graphic_1024x500.png")

def create_screenshot_template():
    """Create screenshot template for guidance"""
    width, height = 1080, 1920
    img = Image.new('RGB', (width, height), DARK)
    draw = ImageDraw.Draw(img)
    
    # Add border
    draw.rectangle([(0, 0), (width-1, height-1)], outline=CYAN, width=4)
    
    # Add title
    try:
        font = ImageFont.truetype("arial.ttf", 36)
    except:
        font = ImageFont.load_default()
    
    title_text = "Screenshot Template"
    title_bbox = draw.textbbox((0, 0), title_text, font=font)
    title_width = title_bbox[2] - title_bbox[0]
    title_x = (width - title_width) // 2
    draw.text((title_x, 50), title_text, fill=CYAN, font=font)
    
    # Add instructions
    instructions = [
        "Take screenshots of your app:",
        "1. Home screen with 'Sudoku by Perfeasy Games'",
        "2. Game screen with Sudoku puzzle",
        "3. Difficulty selection screen",
        "4. Game completion screen",
        "",
        "Size: 1080x1920px or 1080x2340px",
        "Format: PNG",
        "Show the app in action!"
    ]
    
    try:
        instruction_font = ImageFont.truetype("arial.ttf", 24)
    except:
        instruction_font = ImageFont.load_default()
    
    y_pos = 200
    for instruction in instructions:
        draw.text((50, y_pos), instruction, fill=WHITE, font=instruction_font)
        y_pos += 40
    
    # Save
    img.save("playstore_assets/screenshot_template.png")
    print("✅ Created screenshot_template.png")

if __name__ == "__main__":
    print("🎨 Creating Google Play Store assets...")
    
    try:
        create_app_icon()
        create_feature_graphic()
        create_screenshot_template()
        
        print("\n✅ All assets created successfully!")
        print("\n📁 Assets saved in 'playstore_assets' folder:")
        print("   - app_icon_512.png (App icon)")
        print("   - feature_graphic_1024x500.png (Feature graphic)")
        print("   - screenshot_template.png (Screenshot guide)")
        
        print("\n📱 Next steps:")
        print("   1. Take actual screenshots of your app")
        print("   2. Use the assets in Google Play Console")
        print("   3. Upload your APK for review")
        
    except Exception as e:
        print(f"❌ Error creating assets: {e}")
        print("💡 Make sure you have Pillow installed: pip install Pillow")
