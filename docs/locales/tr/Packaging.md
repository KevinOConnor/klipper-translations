# Klipper paketleniyor

Klipper, kurulum ve derleme için setuptools gibi araçları kullanmadığından, Python programları arasında paketleme açısından bir tür anormallik gösterir. Klipper'ı en iyi şekilde paketlemek için bazı notlar şunlardır:

## C modülleri

Klipper, bazı kinematik hesaplamaları daha hızlı gerçekleştirmek için bir C modülü kullanır. Derleyiciye çalışma zamanı bağımlılığının getirilmesini önlemek için bu modülün paketleme zamanında derlenmesi gerekir. C modülünü derlemek için 'python2 klippy/chelper/__init__.py' komutunu çalıştırın.

## Python kodu derleniyor

Çoğu dağıtım, başlatma süresini kısaltmak için tüm Python kodlarını paketlemeden önce derleme politikasına sahiptir. Bunu 'python2 -m compileall klippy' komutunu çalıştırarak yapabilirsiniz.

## Versiyon ayarlanıyor

Klipper paketini git ile oluşturuyorsanız sürüm oluşturma işleminin git olmadan yapılması gerekir. Bunu yapmak için, 'scripts/make_version.py' dosyasını şu betiği kullanarak çalıştırın: 'python2 scripts/make_version.py YOURDISTRONAME > klippy/.version'.

## Örnek pakerleme betiği

Klipper-git Arch Linux için paketlendi. PKGBUILD (yapı betiği), [Arch User Repository](https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=klipper-git)'de bulunabilir.
