# Discontinued
Although discontinued, this project is still available to use however, will not support the new updates that are rolled out for Yucon and Rojo. Rojo 7 is recomended if you would still like to use it.

# About this project
I created this so that people would be able to use the Yucon Coding framework in conjuction with Rojo so that it would be more convenient for developers. I did this by editing the default.project.json file.

# Warning

If you are experiencing errors similar to:

FrameworkServer is not a valid member of ServerScriptService

That means that you have to delete everything that was inserted into your game by rojo (The only things that are inserted are in StarterPlayerScripts, ServerScriptService and ReplicatedStorage) and import Yucon before starting rojo again.

# Placeholder Files
If you are annoyed by the placeholder.txt files, feel free to delete them! However, if the place holder files appear in your game, you can run this code in your studio command bar to get rid of them:

```lua
for _,placeholder in pairs(game:GetDescendants()) do if placeholder:IsA("StringValue") then if placeholder.Value == "Placeholder so that Github will let this folder appear." then placeholder:Destroy() end end end
```

# Disclaimer
I am not affiliated to both Yucon and Rojo's development teams and simply build this project for convenience. If you occur any issues with the products, please contact their developers as I am unable to help you with them.

For more resources on the products, here are some links:

https://devforum.roblox.com/t/yucon-framework-optimization-organization-and-high-level-security/630895

https://rojo.space
