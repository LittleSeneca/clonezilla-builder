# Introduction
[Clonezilla is awesome!](https://clonezilla.org/) By default it has a huge amount of power. But, with a bit of
effort, its existing utility can be greatly expanded. Unfortunately, it can be very cumbersome to unpackage and
repackage a clonezilla image. That is why I built this tool. It efficiently unpackes and repackes clonezilla 
images with changes made to the syslinux, live, home, EFI, and Boot folders. Currently, I have added a boot
menu entry which pulls a user determined github repo and prompts the user to run a script from the pulled repo.

# How to Use the tool
First, you need to have a linux computer. <br/>
Second, you need to download the repo - like this:

    git clone git@github.com:LittleSeneca/clonezilla-builder.git

Third, make the changes you want to make to the contents of the  syslinux, live, home, EFI, and Boot folders <br/>
Fourth, run the command below from the cloned directory:

    sudo ./packer.sh

Fifth, image the resultant .iso file to a usb using the almighty [rufus](https://rufus.ie/)