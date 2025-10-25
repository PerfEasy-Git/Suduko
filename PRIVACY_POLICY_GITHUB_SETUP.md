# How to Host Privacy Policy on GitHub Pages

This guide will help you create a GitHub repository and publish your privacy policy online for Google Play Console.

---

## Step 1: Create GitHub Account (if you don't have one)

1. Go to **https://github.com**
2. Click **Sign up**
3. Create your account (it's free)

---

## Step 2: Create a New Repository

1. Click the **"+" icon** in top right corner
2. Select **"New repository"**
3. Fill in the details:
   - **Repository name:** `sudoku-privacy-policy` (or any name you prefer)
   - **Description:** "Privacy Policy for Sudoku by Perfeasy"
   - **Visibility:** Select **Public** (this is required for free GitHub Pages)
   - **DO NOT** check "Add a README file" (we'll upload the file manually)
4. Click **"Create repository"**

---

## Step 3: Upload Your Privacy Policy

### Option A: Using GitHub Web Interface (Easiest)

1. You'll see a page with "Quick setup" instructions
2. Scroll down and click **"uploading an existing file"** link
3. On the next page, click **"choose your files"** or drag and drop `PRIVACY_POLICY.md`
4. Scroll to the bottom
5. In "Commit changes" section:
   - **Commit message:** "Add privacy policy"
   - Click **"Commit changes"**

### Option B: Using GitHub Desktop (Alternative)

1. Download GitHub Desktop from: https://desktop.github.com/
2. Install and sign in
3. Click **File > Add Local Repository**
4. Clone the repository you just created
5. Copy `PRIVACY_POLICY.md` into the repository folder
6. In GitHub Desktop, you'll see the file listed
7. Add commit message: "Add privacy policy"
8. Click **"Commit to main"**
9. Click **"Push origin"** button

### Option C: Using Git Command Line (Advanced)

```bash
# Navigate to your project folder
cd "D:\Jitin\PerfEasy\Perfeasy-Product\Research\Cursor\Suduko-V1"

# Initialize git (if not already done)
git init

# Add the privacy policy file
git add PRIVACY_POLICY.md

# Commit the file
git commit -m "Add privacy policy"

# Add your GitHub repository as remote
git remote add origin https://github.com/YOUR_USERNAME/sudoku-privacy-policy.git

# Push to GitHub
git push -u origin main
```

---

## Step 4: Enable GitHub Pages

1. In your GitHub repository, click on **Settings** (top right)
2. Scroll down to **Pages** in the left sidebar
3. Under **Source**, select:
   - **Branch:** `main`
   - **Folder:** `/ (root)`
4. Click **Save**

GitHub will now generate a URL for your privacy policy!

---

## Step 5: Get Your Privacy Policy URL

1. Wait 1-2 minutes for GitHub to publish your page
2. GitHub will show a message: **"Your site is live at..."**
3. Your URL will be: `https://YOUR_USERNAME.github.io/sudoku-privacy-policy/PRIVACY_POLICY.md`

**Example URLs:**
- If your username is "johndoe": `https://johndoe.github.io/sudoku-privacy-policy/PRIVACY_POLICY.md`
- If your username is "perfeasy": `https://perfeasy.github.io/sudoku-privacy-policy/PRIVACY_POLICY.md`

---

## Step 6: Test Your URL

1. Copy the URL from GitHub
2. Paste it in a new browser tab
3. You should see your Privacy Policy displayed

---

## Step 7: Add URL to Google Play Console

1. Go to **Google Play Console**: https://play.google.com/console
2. Select your **Sudoku app**
3. In the left menu, click **Store presence** → **Store listing**
4. Scroll down to **"Privacy Policy"** section
5. Paste your GitHub Pages URL:
   ```
   https://YOUR_USERNAME.github.io/sudoku-privacy-policy/PRIVACY_POLICY.md
   ```
6. Click **Save** or **Submit for review**

---

## Troubleshooting

### Issue: "404 Not Found" when accessing URL
**Solution:** 
- Wait 2-3 minutes after enabling Pages
- Make sure repository is **Public**
- Check that the filename is exactly `PRIVACY_POLICY.md`

### Issue: Can't find Settings in repository
**Solution:**
- Make sure you're the repository owner
- Settings tab is only visible to owners/admins

### Issue: Changes not showing on GitHub Pages
**Solution:**
- Make a small change to the file (add a space)
- Commit the change again
- Wait 1-2 minutes for GitHub to rebuild

---

## Tips

✅ **Keep the repository public** - GitHub Pages free tier requires public repos

✅ **Update the policy anytime** - Just edit the file on GitHub and it updates automatically

✅ **Bookmark the URL** - You'll need it for app store submissions

✅ **Test on mobile** - Open the URL on your phone to see how it looks

---

## Next Steps After Publishing

1. ✅ Copy your GitHub Pages URL
2. ✅ Add it to Google Play Console
3. ✅ Test the URL works from different devices
4. ✅ Add a link in your app's Settings screen (optional but recommended)

---

## Quick Reference

| What | Where |
|------|-------|
| **Create Repository** | github.com → + → New repository |
| **Upload File** | Upload existing file (web) or git push (command line) |
| **Enable Pages** | Settings → Pages → Source: main → Save |
| **Get URL** | `https://USERNAME.github.io/REPO-NAME/PRIVACY_POLICY.md` |
| **Update Policy** | Edit file → Commit changes |

---

## Need Help?

- **GitHub Help:** https://docs.github.com/en/pages
- **GitHub Pages Setup:** https://pages.github.com/
- **Email Support:** info@perfeasy.com

Good luck! 🚀


