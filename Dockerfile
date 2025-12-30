FROM ubuntu AS Ubuilder

WORKDIR /SpeedyNote

COPY . /SpeedyNote

RUN apt update -y && apt install -y cmake make pkg-config qt6-base-dev libqt6gui6t64 libqt6gui6 libqt6widgets6t64 libqt6widgets6 qt6-tools-dev libpoppler-qt6-dev libsdl2-dev libasound2-dev

RUN ./build-package.sh && find -name "*.deb" -exec mv {} . \;

FROM fedora AS Fbuilder

WORKDIR /SpeedyNote

COPY . /SpeedyNote

RUN dnf update -y && dnf install -y cmake make pkgconf qt6-qtbase-devel qt6-qttools-devel poppler-qt6-devel SDL2-devel alsa-lib-devel

RUN ./build-package.sh && find -name "*.rpm" -exec mv {} . \;

FROM archlinux AS Abuilder

WORKDIR /SpeedyNote

COPY . /SpeedyNote

RUN pacman -Sy cmake make pkgconf qt6-base qt6-tools poppler-qt6 sdl2-compat alsa-lib

RUN ./build-package.sh && find -name "*.pkgx" -exec mv {} . \;

FROM scratch AS Packer

COPY --from=Ubuilder /SpeedyNote/*.deb /
COPY --from=Fbuilder /SpeedyNote/*.rpm /
COPY --from=Abuilder /SpeedyNote/*.pkgx /
