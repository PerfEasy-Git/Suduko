# 📱 Mobile App Deployment Guide

## 🎯 **Deployment Strategy for Ubuntu Production Server**

### **Option 1: Flutter Web PWA (Recommended)**
Deploy as Progressive Web App that works on mobile browsers.

#### **Step 1: Build Flutter Web App**
```bash
# Build for web
flutter build web --release

# Output will be in build/web/
```

#### **Step 2: Configure PWA**
Add to `web/manifest.json`:
```json
{
  "name": "StoryDoku - Classic Sudoku",
  "short_name": "StoryDoku",
  "description": "A clean, fast Sudoku puzzle game",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#1a1a2e",
  "theme_color": "#00FFFF",
  "icons": [
    {
      "src": "icons/Icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icons/Icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

#### **Step 3: Deploy to Ubuntu Server**
```bash
# Copy build files to your web server
sudo cp -r build/web/* /var/www/html/sudoku/

# Set proper permissions
sudo chown -R www-data:www-data /var/www/html/sudoku/
sudo chmod -R 755 /var/www/html/sudoku/
```

#### **Step 4: Configure Nginx (if using)**
```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/html/sudoku;
    index index.html;

    # Enable gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Handle Flutter web routing
    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

---

### **Option 2: Flutter Mobile APK (Android)**
Build native Android APK for distribution.

#### **Step 1: Install Android SDK on Ubuntu**
```bash
# Install Java
sudo apt update
sudo apt install openjdk-11-jdk

# Download Android SDK
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip commandlinetools-linux-9477386_latest.zip
mkdir -p ~/Android/Sdk/cmdline-tools
mv cmdline-tools ~/Android/Sdk/cmdline-tools/latest

# Set environment variables
echo 'export ANDROID_HOME=~/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
source ~/.bashrc

# Install SDK components
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0"
```

#### **Step 2: Configure Flutter for Android**
```bash
# Accept Android licenses
flutter doctor --android-licenses

# Verify Flutter setup
flutter doctor
```

#### **Step 3: Build APK**
```bash
# Build release APK
flutter build apk --release

# Build app bundle (for Play Store)
flutter build appbundle --release
```

#### **Step 4: Deploy APK**
```bash
# Copy APK to web server for download
sudo cp build/app/outputs/flutter-apk/app-release.apk /var/www/html/sudoku/
sudo chown www-data:www-data /var/www/html/sudoku/app-release.apk
```

---

### **Option 3: Docker Container Deployment**
Deploy as containerized app on Ubuntu.

#### **Step 1: Create Dockerfile**
```dockerfile
# Dockerfile
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable /flutter
ENV PATH="/flutter/bin:${PATH}"

# Set working directory
WORKDIR /app
COPY . .

# Get dependencies
RUN flutter pub get

# Build web app
RUN flutter build web --release

# Install nginx
RUN apt-get install -y nginx

# Copy built app to nginx
RUN cp -r build/web/* /var/www/html/

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
```

#### **Step 2: Build and Run Container**
```bash
# Build Docker image
docker build -t storydoku-app .

# Run container
docker run -d -p 8080:80 --name storydoku storydoku-app
```

---

## 🚀 **Recommended Production Setup**

### **For Ubuntu Server with Existing Apps:**

#### **1. Use Nginx Reverse Proxy**
```nginx
# /etc/nginx/sites-available/sudoku
server {
    listen 80;
    server_name sudoku.yourdomain.com;
    
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

#### **2. Systemd Service**
```ini
# /etc/systemd/system/storydoku.service
[Unit]
Description=StoryDoku Flutter Web App
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/var/www/html/sudoku
ExecStart=/usr/bin/flutter run -d web-server --web-port 8080
Restart=always

[Install]
WantedBy=multi-user.target
```

#### **3. Enable Service**
```bash
sudo systemctl enable storydoku
sudo systemctl start storydoku
```

---

## 📱 **Mobile App Distribution**

### **PWA Installation:**
- Users can "Add to Home Screen" from mobile browser
- Works offline after first load
- Appears like native app

### **APK Distribution:**
- Direct download from your website
- Google Play Store (requires developer account)
- Alternative app stores

### **Web App URL:**
- `https://yourdomain.com/sudoku`
- Mobile-optimized interface
- Works on all devices

---

## 🔧 **Production Checklist**

- [ ] SSL certificate for HTTPS
- [ ] Domain configuration
- [ ] Mobile testing on real devices
- [ ] Performance optimization
- [ ] Analytics integration
- [ ] Error monitoring
- [ ] Backup strategy

---

## 💰 **Cost Considerations**

| Option | Setup Cost | Maintenance | Scalability |
|--------|------------|-------------|-------------|
| **PWA** | Low | Low | High |
| **APK** | Medium | Medium | Medium |
| **Docker** | Medium | Medium | High |

**Recommendation: Start with PWA for quick launch, then add APK for native experience.**

