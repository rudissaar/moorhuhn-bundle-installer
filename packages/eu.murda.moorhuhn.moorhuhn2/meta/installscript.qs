function Component()
{

}

Component.prototype.createOperations = function()
{
    component.createOperations();

    component.addOperation(
        "CreateDesktopEntry",
        "moorhuhn2.desktop",
        "\nEncoding=UTF-8\n" +
        "Name=Moorhuhn 2\n" +
        "Type=Application\n" +
        "Comment=Moorhuhn 2 - Die Jagd geht weiter\n" +
        "Path=@TargetDir@/moorhuhn2\n" +
        "Exec=wine32 @TargetDir@/moorhuhn2/moorhuhn2.exe\n" +
        "Icon=@TargetDir@/moorhuhn2/moorhuhn2.ico\n" +
        "Categories=Game;Emulator;\n" +
        "Terminal=False");
}

