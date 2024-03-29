# Add more folders to ship with the application, here
# folder_01.source = qml/flexitimer
# folder_01.target = qml
folder_02.source = images
folder_02.target = /
DEPLOYMENTFOLDERS = folder_02

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =
INCLUDEPATH += /usr/include/meegotouch
QMAKE_LIBDIR += /usr/lib/meegotouch
LIBS += -lmeegotouchcore

symbian:TARGET.UID3 = 0xE78677D2

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable
CONFIG += qtsparql

# Add dependency to Symbian components
# CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    filehandler.cpp \
    shareuiif.cpp \
    exporter.cpp \
    formatter.cpp

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog \
    qml/flexitimer/* \
    qml/flexitimer/ReportScript.js \
    qml/flexitimer/BusyPanel.qml \
    qml/flexitimer/ExportScript.js \
    qml/flexitimer/SectionDelegate.qml

RESOURCES += \
    resources.qrc

HEADERS += \
    filehandler.h \
    shareuiif.h \
    exporter.h \
    formatter.h















