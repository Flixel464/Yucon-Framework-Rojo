# About this project
I created this so that people would be able to use the Yucon Coding framework in conjuction with Rojo so that it would be more convenient for developers. I did this by editing the default.project.json file.

# Placeholder Files
If you see this placeholder.txt files in your directories, feel free to delete them, however, if they appear in your game, you can run this code in your studio command bar to get rid of them:
```lua
for _,placeholder in pairs(game:GetDescendants()) do if placeholder:IsA("StringValue") then if placeholder.Value == "Placeholder so that Github will let this folder appear." then placeholder:Destroy() end end end
```

# Disclaimer
I am not related to both Yucon and Rojo's development teams and simply build this project for convenience. If you occur any issues with the products, please contact their developers as I am unable to help you with them.

For more resources on the products, here are some links:

https://devforum.roblox.com/t/yucon-framework-optimization-organization-and-high-level-security/630895/55

https://rojo.space
