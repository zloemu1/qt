#include <QResource>

int __stdcall DllMain(void*, unsigned long reason, void*)
{
	if (reason == 1)
		Q_INIT_RESOURCE(qml);
	else if (reason == 0)
		Q_CLEANUP_RESOURCE(qml);
	return 1;
}

extern "C" quint32 V()
{
	return 1;
}
