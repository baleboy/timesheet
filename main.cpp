#include <QtGui/QApplication>
#include <QtDeclarative>
#include "qmlapplicationviewer.h"
#include "exporter.h"
#include "formatter.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QScopedPointer<QmlApplicationViewer> viewer(QmlApplicationViewer::create());

    qmlRegisterType<Exporter,1>("Exporter", 1, 0, "Exporter");
    qmlRegisterType<Formatter,1>("Formatter", 1, 0, "Formatter");

    viewer->setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    // viewer->setMainQmlFile("qrc:///qml/main.qml");// QLatin1String("qml/flexitimer/main.qml"));
    viewer->setSource(QUrl("qrc:///qml/flexitimer/main.qml"));
    viewer->showExpanded();

    return app->exec();
}
