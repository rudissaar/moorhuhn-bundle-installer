function Component()
{

}

Component.prototype.createOperations = function()
{
    component.createOperations();

    component.addOperation(
        "CreateDesktopEntry",
        "moorhuhnjagd.desktop",
        "\nEncoding=UTF-8\n" +
        "Name=Moorhuhnjagd\n" +
        "Type=Application\n" +
        "Comment=Moorhuhjagd\n" +
        "Path=@TargetDir@\n" +
        "Exec=wine32 @TargetDir@/moorhuhnjagd.exe\n" +
        "Icon=@TargetDir@/moorhuhnjagd.exe\n" +
        "Categories=Game;Emulator;\n" +
        "Terminal=False");
}

