/*

Copyright (C) 2012 Francesco Balestrieri

This file is part of Timesheet for N9

Timesheet for N9 is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Timesheet for N9 is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Timesheet for N9.  If not, see <http://www.gnu.org/licenses/>.

*/

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
