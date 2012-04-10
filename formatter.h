#ifndef FORMATTER_H
#define FORMATTER_H

#include <QObject>
#include <QDateTime>

class MLocale;

class Formatter : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool monthFirst READ monthFirst NOTIFY localeChanged)

public:
    explicit Formatter(QObject *parent = 0);
    ~Formatter();

    Q_INVOKABLE QString formatTime(QDateTime dateTime);
    Q_INVOKABLE QString formatTimeLong(QDateTime dateTime);
    Q_INVOKABLE QString formatDateLong(QDateTime dateTime);
    Q_INVOKABLE QString formatDateShort(QDateTime dateTime);
    Q_INVOKABLE QString formatDateFull(QDateTime dateTime);
    Q_INVOKABLE QString formatDateYearAndMonth(QDateTime dateTime);
    Q_INVOKABLE QString formatDateTime(QDateTime dateTime);
    bool monthFirst();


public slots:

    void onLocaleSettingsChanged();

signals:

    void localeChanged();

private:
    MLocale* m_mLocale;
    bool m_monthFirst;

    bool isMonthFirst();
};

#endif // FORMATTER_H
