function Component()
{

}

Component.prototype.createOperations = function()
{
    component.createOperations();

    component.addOperation(
        "CreateDesktopEntry",
        "moorhuhn3.desktop",
        "\nEncoding=UTF-8\n" +
        "Name=Moorhuhn 3\n" +
        "Type=Application\n" +
        "Comment=Moorhuhn 3 - Moorhuhn 3 - Es gibt Huhn!\n" +
        "Path=@TargetDir@/moorhuhn3\n" +
        "Exec=wine32 @TargetDir@/moorhuhn3/moorhuhn3.exe\n" +
        "Icon=@TargetDir@/moorhuhn3/moorhuhn3.ico\n" +
        "Categories=Game;Emulator;\n" +
        "Terminal=False");
}

