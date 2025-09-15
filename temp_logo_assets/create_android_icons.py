#!/usr/bin/env python3

from PIL import Image, ImageDraw
import os

def create_truck_logo(size, transparent=True):
    """Create a truck logo at the specified size"""
    # Create image with transparent or white background
    if transparent:
        img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    else:
        img = Image.new('RGBA', (size, size), (255, 255, 255, 255))
    
    draw = ImageDraw.Draw(img)
    
    # Scale factor based on size
    scale = size / 100
    
    # Colors
    truck_blue = (41, 128, 185)  # Professional blue
    truck_dark = (52, 73, 94)   # Dark gray
    wheel_color = (44, 62, 80)  # Darker gray for wheels
    
    # Draw truck cab (left part)
    cab_width = int(35 * scale)
    cab_height = int(25 * scale)
    cab_x = int(15 * scale)
    cab_y = int(40 * scale)
    
    draw.rectangle([cab_x, cab_y, cab_x + cab_width, cab_y + cab_height], 
                   fill=truck_blue, outline=truck_dark, width=max(1, int(2 * scale)))
    
    # Draw truck trailer (right part)
    trailer_width = int(40 * scale)
    trailer_height = int(30 * scale)
    trailer_x = cab_x + cab_width
    trailer_y = int(35 * scale)
    
    draw.rectangle([trailer_x, trailer_y, trailer_x + trailer_width, trailer_y + trailer_height], 
                   fill=truck_blue, outline=truck_dark, width=max(1, int(2 * scale)))
    
    # Draw cab window
    window_size = int(8 * scale)
    window_x = cab_x + int(5 * scale)
    window_y = cab_y + int(5 * scale)
    
    draw.rectangle([window_x, window_y, window_x + window_size, window_y + window_size], 
                   fill=(173, 216, 230), outline=truck_dark, width=max(1, int(1 * scale)))
    
    # Draw wheels
    wheel_radius = int(8 * scale)
    
    # Front wheel
    front_wheel_x = cab_x + int(8 * scale)
    front_wheel_y = cab_y + cab_height + int(5 * scale)
    
    draw.ellipse([front_wheel_x - wheel_radius, front_wheel_y - wheel_radius,
                  front_wheel_x + wheel_radius, front_wheel_y + wheel_radius], 
                 fill=wheel_color, outline=truck_dark, width=max(1, int(2 * scale)))
    
    # Back wheel
    back_wheel_x = trailer_x + int(30 * scale)
    back_wheel_y = trailer_y + trailer_height + int(5 * scale)
    
    draw.ellipse([back_wheel_x - wheel_radius, back_wheel_y - wheel_radius,
                  back_wheel_x + wheel_radius, back_wheel_y + wheel_radius], 
                 fill=wheel_color, outline=truck_dark, width=max(1, int(2 * scale)))
    
    # Add some details to the trailer
    detail_x = trailer_x + int(5 * scale)
    detail_y = trailer_y + int(5 * scale)
    detail_width = int(30 * scale)
    detail_height = int(20 * scale)
    
    draw.rectangle([detail_x, detail_y, detail_x + detail_width, detail_y + detail_height], 
                   fill=None, outline=truck_dark, width=max(1, int(1 * scale)))
    
    return img

def main():
    # Create temp directory if it doesn't exist
    os.makedirs('temp_logo_assets', exist_ok=True)
    
    # Android icon sizes and their directories
    android_sizes = [
        (48, 'android/app/src/main/res/mipmap-mdpi'),
        (72, 'android/app/src/main/res/mipmap-hdpi'),
        (96, 'android/app/src/main/res/mipmap-xhdpi'),
        (144, 'android/app/src/main/res/mipmap-xxhdpi'),
        (192, 'android/app/src/main/res/mipmap-xxxhdpi'),
    ]
    
    print("🚛 Creating Android app icons...")
    
    # Generate Android icons
    for size, directory in android_sizes:
        # Create directory if it doesn't exist
        os.makedirs(directory, exist_ok=True)
        
        # Create icon
        icon = create_truck_logo(size, transparent=False)  # Android icons should not be transparent
        
        # Save icon
        icon_path = os.path.join(directory, 'ic_launcher.png')
        icon.save(icon_path, 'PNG')
        print(f"✅ Created {size}x{size} icon: {icon_path}")
    
    print("🎉 All Android icons created successfully!")

if __name__ == "__main__":
    main()
