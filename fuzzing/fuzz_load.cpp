// Fuzzing harness for BinarySerializer::load().
// Input bytes are saved as a temporary .bin file and loaded by the application.

#include "binaryserializer.h"
#include "raspored.h"

#include <QCoreApplication>
#include <QFile>
#include <QTemporaryDir>

static QCoreApplication *g_app = nullptr;

extern "C" int LLVMFuzzerInitialize(int *argc, char ***argv) {
  static int fakeArgc = 1;
  static char fakeArg0[] = "fuzz_load";
  static char *fakeArgv[] = {fakeArg0, nullptr};

  g_app = new QCoreApplication(fakeArgc, fakeArgv);

  return 0;
}

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  QTemporaryDir dir;
  if (!dir.isValid()) {
    return 0;
  }

  const QString fileName = "fuzz.bin";
  QFile file(dir.filePath(fileName));

  if (!file.open(QIODevice::WriteOnly)) {
    return 0;
  }

  file.write(reinterpret_cast<const char *>(data), static_cast<qint64>(size));
  file.close();

  BinarySerializer serializer(dir.path());
  Raspored raspored;
  serializer.load(raspored, fileName);

  return 0;
}