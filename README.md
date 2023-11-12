# Strømpris

Jeg fikk det bare for meg at jeg ville ha en app der jeg kunne sjekke hvor "dyrt" det er å bruke gulvovnen min med den gjeldende strømprisen. Ovnen min har instillinger for 2000 kW, 1250 kW og 750 kW.

<img src="https://github.com/ssredna/remaining-movies/assets/33721320/ff5b82bb-8b52-4cdc-b3b3-64f131ca90c8" width="200" alt="Screenshot of Strompris-app">

Prisen er inkludert nettleie og strømstøtte.

## Forbedringspotensiale

Dette er en veldig enkel app. Det var også poenget, da den ikke skulle ta lang tid å utvikle, ved siden av eksamenslesingen. Når det er sagt, så dukker det fort opp idéer til forbedring når man holder på.

- Mer detaljer. F.eks. at man kan trykke på dagens pris, og så kommer det en liten dropdown som bryter ned hva prisen består av (f.eks. mva og nettleie)
- Graf for resten av dagen. Det er jo greit nok å vite hva strømmen koster akkurat nå, men burde jeg sette på ovnen nå, eller vente en time? Det kan være greit å se pris-utviklingen utover dagen, noe en enkel graf kunne vist.

Kanskje i juleferien.

# Teknologi

Her er en kjapp gjennomgang av hvilke teknologi jeg har brukt.

## Flutter

Jeg gikk for flutter, og det var raskt og enkelt å få gjennomført en slik liten app med det. Det var ikke mye avansert jeg holdt på med i denne appen, men her er et par nevneverdige Widgets.

### FutureBuilder

Jeg bruker en `FutureBuilder` for å vise en loading-spinner mens den henter strømprisene. Den gir deg et `snapshot` av dataen, som du kan sjekke status på for å bygge det du vil.

```dart
FutureBuilder<Strompriser>(
  future: _futureStrompriser,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text(
        '${snapshot.data!.nokPerKwhWithNettleie.toStringAsFixed(2)} NOK'),
    } else if (snapshot.hasError) {
      return Text('${snapshot.error}');
    }
    return const CircularProgressIndicator();
  }
)
```

Av en eller annen grunn så må jeg fortsatt bruke `snapshot.data!` for å tvinge VS Code til å skjønne at snapshot har data inne i den if-en.

### RichText

Fikk også testet hvordan det er å gjøre inline text-styling, da jeg ville ha selve prisen i litt større font en resten av linjen. Da kan man bruke en `RichText`, og så legge inn flere `TextSpan`s, som dette:

```dart
Text.rich(TextSpan(
  style: Theme.of(context).textTheme.bodyLarge,
  children: [
    const TextSpan(
      text: '2000 kW: ',
    ),
    TextSpan(
      text: (snapshot.data!.nokPerKwhWithNettleie * 2)
        .toStringAsFixed(1),
      style:
        Theme.of(context).textTheme.headlineSmall,
    ),
    const TextSpan(
      text: ' kr/t',
    )
  ])),
```

Her føler jeg også Flutter viser litt av sin svakhet, i at det blir veldig mye "styr" bare for å style den ene biten av teksten litt større en resten. Hvis alt skulle vært i samme stil hadde jeg hatt dette istedenfor:

```dart
Text(
  '2000 kW: ${(snapshot.data!.nokPerKwhWithNettleie * 2).toStringAsFixed(1)} kr/t',
  style: Theme.of(context).textTheme.bodyLarge,
),
```

Fra 4 til 16 linjer...

Men hey, jeg er jo en ganske uerfaren Flutter-utvikler, det kan være at jeg bare misser noe her.

## API

<p><a href="https://www.hvakosterstrommen.no"><img src="https://ik.imagekit.io/ajdfkwyt/hva-koster-strommen/strompriser-levert-av-hvakosterstrommen_oTtWvqeiB.png" alt="Strømpriser levert av Hva koster strømmen.no" width="200" height="45"></a></p>

Jeg har brukt <a href="https://www.hvakosterstrommen.no">hvakosterstrømmen.no</a> for å finne strømprisene. Veldig enkelt og greit API.
