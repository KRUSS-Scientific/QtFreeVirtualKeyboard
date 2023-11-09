#-------------------------------------------------
#
# Project created by QtCreator 2013-04-04T23:11:38
#
#-------------------------------------------------

QT  += qml quick quick-private gui-private

CONFIG += plugin

TARGET = freevirtualkeyboardplugin
TEMPLATE = lib


SOURCES += VirtualKeyboardInputContextPlugin.cpp \
    VirtualKeyboardInputContext.cpp \
    DeclarativeInputEngine.cpp

HEADERS += VirtualKeyboardInputContextPlugin.h\
    VirtualKeyboardInputContext.h \
    DeclarativeInputEngine.h


deployment.files = *.qml FontAwesome.otf qmldir
deployment_layouts.files = layouts/*.qml


linux-buildroot-g++ {
    deployment.path = /usr/qml/QtQuick/FreeVirtualKeyboard
    deployment_layouts.path = /usr/qml/QtQuick/FreeVirtualKeyboard/layouts
    target.path = /usr/lib/qt/plugins/platforminputcontexts
} else {
    deployment.path = $$[QT_INSTALL_QML]/QtQuick/FreeVirtualKeyboard
    deployment_layouts.path = $$[QT_INSTALL_QML]/QtQuick/FreeVirtualKeyboard/layouts
    target.path = $$[QT_INSTALL_PLUGINS]/platforminputcontexts
}


INSTALLS += target \
    deployment \
    deployment_layouts

OTHER_FILES += \
    InputPanel.qml \
    KeySelector.qml \
    KeyButton.qml \
    KeyPopup.qml \
    LayoutSelector.qml \
    layouts/Layout_en_US.qml

RESOURCES += \
    virtualkeyboard.qrc

DISTFILES += \
    KeySelector.qml \
    LayoutSelector.qml \
    layouts/Layout_en_US.qml
