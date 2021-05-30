Never try to directly `make install` into `/usr` (no matter `/usr` or `/usr/local`). Package Managers are there to help you.

Although Debian/Ubuntu doesn't provide tools like AUR in Archlinux, it's quite easy to package a simple `.deb` to take advantage of `apt`.

Clone this repo and find the package which you want. `cd` into that subdirectory, run the `compile.sh`, and follow the steps.

Credit to: [Lubos Rendek: Easy way to create a Debian package and local package repository](https://linuxconfig.org/easy-way-to-create-a-debian-package-and-local-package-repository)

# See Also

- Debian doc about `DEBIAN/control`: [Control files and their fields](https://www.debian.org/doc/debian-policy/ch-controlfields.html)