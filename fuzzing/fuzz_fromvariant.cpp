// Fuzzing harness for Artikl::fromVariant() and Kategorija::fromVariant().
// Input bytes are deserialized into a QVariant using QDataStream.

#include "artikl.h"
#include "kategorija.h"

#include <QByteArray>
#include <QDataStream>
#include <QGuiApplication>
#include <QVariant>

static QGuiApplication *g_app = nullptr;

extern "C" int LLVMFuzzerInitialize(int *argc, char ***argv) {
  static int fakeArgc = 1;
  static char fakeArg0[] = "fuzz_fromvariant";
  static char *fakeArgv[] = {fakeArg0, nullptr};

  g_app = new QGuiApplication(fakeArgc, fakeArgv);

  return 0;
}

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
  constexpr size_t kMaxInputSize = 1024 * 1024;

  if (size > kMaxInputSize) {
    return 0;
  }

  QByteArray bytes(reinterpret_cast<const char *>(data), static_cast<int>(size));
  QDataStream stream(bytes);
  QVariant variant;
  stream >> variant;

  if (stream.status() != QDataStream::Ok) {
    return 0;
  }

  Artikl artikl;
  artikl.fromVariant(variant);

  Kategorija kategorija;
  kategorija.fromVariant(variant);

  return 0;
}