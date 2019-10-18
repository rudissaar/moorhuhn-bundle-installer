function Component()
{

}

Component.prototype.createOperations = function()
{
    component.createOperations();

    component.addOperation(
        "CreateDesktopEntry",
        "moorhuhnwinter.desktop",
        "\nEncoding=UTF-8\n" +
        "Name=Moorhuhn Winter-Edition\n" +
        "Type=Application\n" +
        "Comment=Moorhuhn Winter-Edition\n" +
        "Path=@TargetDir@/moorhuhnwinter\n" +
        "Exec=wine32 @TargetDir@/moorhuhnwinter/moorhuhnwinter.exe\n" +
        "Icon=@TargetDir@/moorhuhnwinter/moorhuhnwinter.ico\n" +
        "Categories=Game;Emulator;\n" +
        "Terminal=False");
}

