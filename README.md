# 2026_Analysis_Expresso

Seminarski rad iz predmeta **Verifikacija softvera** na Matematičkom fakultetu Univerziteta u Beogradu.

## Autor

Ime i prezime: Valentina Tošić

Broj indeksa: 1022/25

## Opis projekta

Analiziran je projekat **Expresso**, Qt6/C++ desktop aplikacija namenjena radu kafića, koja omogućava upravljanje stolovima, rasporedom i porudžbinama.

Originalni projekat dostupan je na adresi:

https://gitlab.com/matf-bg-ac-rs/course-rs/projects-2023-2024/Expresso.git

Grana projekta na kojoj je izvršena analiza: `main`

Heš analiziranog commit-a: `550b8730171a7d990e3487f6efee1bd5875bfe9d`

## Priprema projekta

Pre pokretanja analiza potrebno je inicijalizovati Git submodule:

```bash
git submodule update --init --recursive
```

Zatim je potrebno primeniti izmene potrebne za prevođenje i testiranje projekta:

```bash
git apply custom.patch
```

Alati korišćeni tokom analize mogu se instalirati pomoću:

```bash
sudo apt install -y qt6-base-dev valgrind heaptrack clang-21 clang-tidy-21 libclang-rt-21-dev clazy lcov
```

Nakon toga možemo pokrenuti skriptu `build.sh`, koja će prevesti projekat i generisati izvršne fajlove aplikacije i testova:

```bash
./build.sh
```


## custom.patch

Originalni projekat nije bilo moguće direktno prevesti i pokrenuti bez određenih izmena, a pošto je projekat uključen kao Git submodule, izmene nisu napravljene direktno u njemu, već su sačuvane u fajlu `custom.patch`.

Patch sadrži izmene potrebne za uspešno prevođenje i pokretanje testova, kao i dodatne testove za klase koje nisu imale dovoljnu pokrivenost.

## Korišćeni alati

| Alat                         | Namena                                           | Direktorijum  |
| ---------------------------- | ------------------------------------------------ | ------------- |
| Catch2 + lcov                | Jedinično testiranje i analiza pokrivenosti      | `unit_tests/` |
| Valgrind                     | Dinamička analiza memorije                       | `valgrind/`   |
| libFuzzer + AddressSanitizer | Fuzzing i detekcija grešaka pri deserijalizaciji | `fuzzing/`    |
| Clang-Tidy                   | Statička analiza C++ koda                        | `clang-tidy/` |
| Clazy                        | Statička analiza Qt koda                         | `clazy/`      |
| Heaptrack                    | Profilisanje korišćenja memorije                 | `heaptrack/`  |

Svaki direktorijum sadrži rezultate odgovarajuće analize i skriptu za njeno ponovno pokretanje.

## Zaključak

Nakon analize Expresso aplikacije uočeni su funkcionalni problemi, propusti u kodu i curenja memorije. Testiranjem (Catch2) i statičkom analizom (Clang-Tidy, Clazy) detektovani su problemi sa neinicijalizovanim pokazivačima i logičkim greškama, dok su Valgrind, Heaptrack i fuzzing (libFuzzer + AddressSanitizer) otkrili curenja memorije i nedovoljnu zaštitu pri deserijalizaciji ulaznih fajlova.

Detaljniji izveštaj sa nalazima i preporukama za izmenu koda može se pronaći u fajlu ProjectAnalysisReport.pdf.