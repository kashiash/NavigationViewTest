

Temat pochodzi z prezentacji WWDC związanej z nawigacją w SwiftUI Cookbook. Więc wcześniej mieliśmy widok nawigacji, a żeby zmienić ten styl, musieliśmy użyć stylu widoku nawigacji na stosie, co oznaczało typową nawigację na iPhone'ie, gdzie mamy tylko główny ekran, a potem dodajemy nowe widoki na wierzch, czyli nakładamy nakładki na siebie. Nowe API ma specjalny widok na to, którym jest nawigacyjny stos. Inny styl nawigacji to podwójna kolumna lub wielokolumnowy. Jest to interesujące dla macOS i iPodOS. Dla tego mamy osobny widok, którym jest nawigacyjny widok podziału. 

|                          Poprzednio                          | Obecnie                         |
| :----------------------------------------------------------: | ------------------------------- |
|        NavigationView {...}. navigationStyle(.stack)         | NavigationStack                 |
|                        NavigationView                        | NavigationSplitView             |
| NavigationLink(... isActive: ...) NavigationLink(... tag: ... selection: ...) | NavigationLink (... value: ...) |

W tym pierwszym samouczku chcę porozmawiać o stosie nawigacji i zawrę także wszystkie aktualizacje dla linków nawigacyjnych. Ponieważ nowe API nawigacji działa lepiej, także dzięki tym aktualizacjom, wszystko to ze sobą współgra. Jeśli wcześniej korzystałeś z linków nawigacyjnych z opcjami „isActive” i „selection”, to teraz są one przestarzałe, ponieważ teraz podejście jest inne, aby mieć dostęp do stanu nawigacji i właściwości „path” stosów nawigacyjnych. Przyjrzymy się również temu. Teraz link nawigacyjny został podzielony na dwie różne opcje.

Jednym z nich jest link nawigacyjny, który jest oparty na wartości, więc określasz typ wartości, dla której ten link jest aktywny. W tej pozycji nie określasz, jaki widok ma być pokazany jako cel dla tego linku. Dla tego celu mamy inny modyfikator widoku, którym jest nawigacyjny cel, ponownie z wartością, więc istnieje połączenie między nimi, mamy teraz nawigację opartą na wartości lub typie. Zobaczysz pewne konsekwencje tego i pewne ograniczenia. Próbuję przedstawić Ci kilka różnych przykładów i naprawdę staram się znaleźć więcej ograniczeń i błędów. Nie znalazłem ich zbyt wiele, więc to dobrze. Tylko niektóre animacje nie są idealne, ale trzeba przyznać, że i tak jest lepiej niż wcześniej. Chcę także przejść do nieco bardziej złożonej nawigacji z różnymi typami i różnymi widokami szczegółowymi oraz wieloma widokami szczegółowymi w stosie. Aby to osiągnąć, musimy trochę porozmawiać o tym, jak zaprojektować i jak zdefiniować nasz stan dla nawigacji, którą obsługujemy. Więc ta ścieżka nawigacji jest nieco bardziej złożona. To ważne, ponieważ wiele problemów, z którymi się borykasz, również wcześniej, wynikało z tego, że nie zajmowałeś się tym właściwie, mnie również. Czasami dzieje się tak po prostu dlatego, że masz niezdefiniowane stany, ponieważ nie masz jednego źródła prawdy. Przyjrzymy się jednemu możliwemu podejściu, które znalazłem bardziej użyteczne. Na koniec chciałbym porozmawiać o przywracaniu stanu. Niestety nie jest to tak proste, jak miałem nadzieję. Można to zrobić, pokażę Ci sposób, który zaproponowali w przykładowym projekcie. Pokażę Ci podejście nieco zmodyfikowane, które użyli w prezentacji na WWDC. Jest to korzystanie z combine i async array razem. Jest to trochę dziwne, ale działa, ma sens i łatwo możesz użyć tego dla swoich własnych potrzeb.

Tak więc nawet jeśli nie znasz tych frameworków doskonale, nadal możesz je dostosować do swoich potrzeb. To jest dobre. Ten samouczek będzie dość długi, dlatego zacząłem od nawigacji stosowej, a później będziemy rozmawiać o nawigacyjnych widokach podzielonych. To jest bardziej uniwersalne narzędzie, które działa wszędzie. Zacznijmy od utworzenia nowego projektu. Będę używać wieloplatformowości, ponieważ może chcesz zobaczyć, jak to wygląda na macOS. Następnie muszę mu nadać nazwę np NavigationStackTest. Nie używam CoreData/SwiftData ani żadnych testów jednostkowych. Skorzystam tutaj z symulatora iPhone'a, ponieważ to jest główny przypadek użycia. Teraz, ponieważ chcę pokazać Ci różne przykłady, będę ich używać i chcę umieścić wszystko w tym samym projekcie, abyś mógł łatwiej to przetestować. Końcowy projekt będzie dostępny w repozytorium na GitHubie. Chcę mieć wiele różnych przykładów stosu nawigacji, które osadzę w widoku zakładek, dzięki czemu będziesz mógł wszystko ładnie przetestować. Będziemy tworzyć trzy różne przykłady, które umieścimy w trzech różnych grupach.

![image-20231108115612981](image-20231108115612981.png)

 W pierwszej utworzę nowy plik Command+N i wybieram SwiftUI View. To będzie `FirstTabView`. Głównie będę mógł używać widoku z podglądem na żywo. Musimy być tutaj na lewym przycisku, aby zobaczyć to w akcji. Dobrze, pierwszą rzeczą, którą chcę zrobić, to przetestować różne linki nawigacyjne, które chcemy użyć. Jeden z problemów polega na tym, że na liście podpowiedzi mamy zbyt wiele tych widoków. Zacznijmy od nawigacji. Już teraz widzisz przy niektorych wariantach, ostrzeżenia po prawej stronie, ponieważ są one przestarzałe. Tak więc mamy NavigationStack i mamy dwie metody inicjalizacji: jedna tylko z widokiem, a druga z tą ścieżką.

![image-20231108120624763](image-20231108120624763.png)

Więc to jest ta wiązanie ścieżki nawigacji, o której za chwilę porozmawiamy. Teraz wybieram prostszą opcję, która polega tylko na zdefiniowaniu widoku. Tutaj możesz zdefiniować swój główny widok lub widok podstawowy stosu nawigacyjnego. To jest widok podstawowy, a teraz przejdźmy do linku nawigacyjnego. Więc mamy tutaj nowe, związane z tą wartością, i widzisz, że informuje nas, że wartość musi być `hashable`. 

![image-20231108121052228](image-20231108121052228.png)

Ta koncepcja będzie Ci potrzebna wszędzie, również dla naszych własnych niestandardowych typów, więc miej to na uwadze. Następnie mamy tytuł i cel. To jest starsza wersja. To samo dla celu. One nadal działają, chociaż widzisz pewne ograniczenia tego celu. Szukamy tego z wartością. Dobrym wyborem jest tytuł i wartość lub wartość i etykieta. Zaczniemy od tytułu i klucza wartości. Nie mam teraz jakichś wyrafinowanych definicji przycisków. Więc jest to „Przejdź do szczegółów”, a teraz musisz podać swoją wartość. Co oznacza ta wartość? To podstawowe informacje, które chcesz pokazać w widoku szczegółów. Powiedzmy, że mam tutaj ciąg znaków, który mówi „pokaż A”. 

![image-20231108121747848](image-20231108121747848.png)

Teraz mamy ten przycisk na podglądzie i  mogę go kliknąć, ale nic się nie dzieje. Dzieje się tak, ponieważ nie zdefiniowaliśmy żadnego celu. Nie ma tutaj widoku, który mówi, co ma się pokazać, gdy naciśnę ten przycisk. To różni się od tego, co mieliśmy wcześniej. W starszej wersji link nawigacyjny z docelowym widokiem, tutaj od razu mieliśmy widok docelowy. W przypadku nowego linku opartego na wartościach oddzielamy, kiedy ten link jest faktycznie aktywowany. Więc ta część dotyczy aktywacji przesunięcia na nowy widok.

Drugą częścią jest modyfikator widoku, którym jest nawigacyjny cel. Posiada on dwie różne metody inicjalizacji: „destination(for:)” oraz „presented(for:)”. Tutaj znowu pojawia się haszowalna wartość. Musisz zdefiniować typ dla tej wartości. Następnie mamy domknięcie, w którym możemy określić, jaki widok chcemy pokazać jako cel. Mamy tutaj także metodę „presented”, więc można również aktywować link w ten sposób. Na razie użyjemy „destination(for:)”, ponieważ używam wersji opartej na wartości. I co to oznacza ta wartość? Muszę użyć tego samego typu wartości, jakiego zdefiniowałem tutaj. Tutaj powiedziałem, że moją wartością jest ciąg znaków. Więc ten nawigacyjny cel musi być zgodny z tym samym typem, którym jest „string.self”. To jest sposób określenia, jakiego typu używamy. A teraz w zamknięciu pobieram wartość z mojej wartości. 

```swift
NavigationLink("Goto detail view",value: "Show AAA")
.navigationDestination(for: String.self) 
{ textValue in
     Text("detail with value: \(textValue)")
}
```

To jest moja wartość tekstowa w tym przypadku. I mogę powiedzieć „detail with value”. Teraz, jeśli naciśnę „szczegóły”, powinienem być w stanie przesunąć się na nowy widok, i rzeczywiście widzimy widok i docelowy widok, który zdefiniowałem tutaj, z „szczegółami z wartością a”. Na razie połączyłem link z docelowym widokiem. 

![2023-11-08_12-22-40 (1)](2023-11-08_12-22-40%20(1).gif)

Masz dowolność i możesz tak zrobić. Ale fajne jest to, że teraz masz także wolność, żeby tego nie robić. Na przykład w przypadku, gdy masz tutaj leniwy widok, powiedzmy, że mam listę moich linków nawigacyjnych na liście, która jest leniwa. To nie jest dobry pomysł, ponieważ tworzę i usuwam te widoki, a każdy z tych przycisków tych linków otrzymuje swoją własną destynację. Zwłaszcza, jeśli masz wiele tych linków. Powiedzmy, że mam drugi, który pokazuje B. Teraz ten przycisk mówi „przejdź do B”. I widzisz, że pokazuje mi tekstową wartość, którą zdefiniowałem tutaj. Jeśli przejdę do drugiego, pokazuje mi AAA. Więc ten modyfikator widoku nawigacyjnego celu jest używany dla wszystkich wartości z ciągiem znaków. 

```swift
            VStack {
                Text("Root View")
                NavigationLink("Goto detail view A",value: "Show AAA")
                    .navigationDestination(for: String.self) { textValue in
                        Text("detail with value: \(textValue)")
                    }
                NavigationLink("Goto detail view B",value: "Show BBB")
                .navigationDestination(for: String.self)
                { textValue in
                     Text("detail with value: \(textValue)")
                }
                NavigationLink ("Old link with destination ") {
                    Text("Old navigation link")
                }
            }
```

Więc nie powinniśmy tego robić. W tym przypadku prawdopodobnie przeniosę go poza listę. Teraz jest łatwiej zobaczyć, że wewnątrz listy mam swoje linki, a na zewnątrz jest cel. Spróbujmy uczynić to trochę bardziej czytelnym, tworząc widok szczegółowy. 

```swift
        NavigationStack {
            List {
                Text("Root View")
                NavigationLink("Goto detail view A",value: "Show AAA")

                NavigationLink("Goto detail view B",value: "Show BBB")

                NavigationLink ("Old link with destination ") {
                    Text("Old navigation link")
                }
            }
            .navigationDestination(for: String.self) { textValue in
                Text("detail with value: \(textValue)")
            }
        }
```

 Będę go używać dla wszystkich wartości tekstowych, więc prawdopodobnie każdy z tych widoków szczegółowych otrzyma różny tekst, który jest ciągiem znaków. Teraz mogę tutaj w podglądzie napisać cokolwiek chcesz. Ja używam tylko liter, ponieważ wtedy łatwo zobaczę, co faktycznie przesuwam. To jest na razie. Powiedzmy, że mogę powiedzieć, że to jest mój widok szczegółowy pokazujący. I chciałem użyć tego tekstu gdzieś. W tym przypadku będziemy po prostu używać nawigacyjnego tytułu dla tego. 

```swift
import SwiftUI

struct DetailView: View {
    let text: String
    var body: some View {

        VStack {
            Text("Detail showing")
            Text(text)
        }
        .navigationTitle(text)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DetailView(text: "AAA BBB CCCC")
}
```

 Okej, mam teraz ten widok szczegółowy `DetailView` i w moim pierwszym widoku zakładki, kiedy tworzę tutaj ten navigationDestination, mogę użyć widoku szczegółowego, pokazującego tekstową wartość, którą przekazałem jako parametr:

```swift
            .navigationDestination(for: String.self) { textValue in
                //Text("detail with value: \(textValue)")
                DetailView(text: textValue)
            }
```

Więc w zależności od tego, który link używam, to jest albo ta wartość, albo ta wartość.  Już powiedziałem, że jest to nawigacja oparta na wartościach lub typach, ponieważ zawsze, gdy piszesz, zawsze dopasowuje wartość linku do celu. Na przykład, jeśli teraz zmienisz i powiesz, że idźmy do numeru jeden, a teraz pokazuję tutaj liczbę całkowitą.

```swift
 NavigationLink("Goto detail view 1",value: 1)
```

 I link pojawia się na widoku poprawnie, ale nic nie robi, ponieważ typy nie pasują - apliakcj anie znajduje destination dla tego typu. Jedyne miejsce, do którego mogę przejść, to dla ciągu znaków, nie dla liczby całkowitej. Możesz dodać tyle nawigacyjnych celów, ile chcesz. Więc dla typu miałem tutaj liczbę całkowitą. 

```swift
            .navigationDestination(for: Int.self) { intValue in
                Text("detail with INT value: \(intValue)")
            }
```

Okej, teraz gdy kliknę w link z liczbą, użyje tego widoku szczegółowego i zobaczysz szczegóły tej liczby. W przypadku, gdy naciśnę jeden z tych ciągów znaków, zobaczę widok docelowy dla tych ciągów znaków. Możesz dodać tyle różnych typów, ile chcesz. Nie możesz mieć różnych destynacji dla tego samego typu, ponieważ wtedy nie wie, którą wybrać i ignoruje drugą. Możesz zrobić to samo dla swoich niestandardowych typów. 

​	Teraz spójrzmy tylko na inny nawigacyjny cel, który jest „presented”. Powiedzmy, że chcę pokazać widok ustawień, ponieważ dla ustawień nie mam wartości specjalnie dla tego. To po prostu pokazuj lub nie. Więc dodajemy

```swift
@State private var showSettings = false
```

”Teraz tutaj mogę użyć tego wiązania i dla widoku ustawień, tylko w celach testowych, ma po prostu pokazać ustawienia. 

```swift
            .navigationDestination(isPresented: $showSettings) {
                Text("Settings")
            }
```

Teraz muszę faktycznie przełączyć tę właściwość, a do tego mogę użyć prostego przycisku i powiedzieć „showSettings.toggle” i jako etykietę prawdopodobnie powiedzieć po prostu „Ustawienia”. 

```swift
    var body: some View {
        NavigationStack {
            List {...}
                Button("Show settings") {
                    showSettings.toggle()
                }
            }
      ....
    		}   
				.navigationDestination(isPresented: $showSettings) {
                Text("Settings")
        }
```

Ponieważ używam przycisku, wygląda to tak samo. Jedna z rzeczy związanych z listą, to zawsze masz różne typy, ale linki wciąż działają. Więc mamy ten, który pojawia się teraz. 

![2023-11-08_15-51-36 (1)](2023-11-08_15-51-36%20(1).gif)

​	Teraz mamy wszystkie te różne linki. Niektóre z nich są stare, więc może utworzę osobną sekcję `Stare`. 

```swift
                Section ("Old"){
                    NavigationLink ("Old link with destination ") {
                        Text("Old navigation link")
                    }
                }
```

Rzecz w tym, że stare i nowe, czyli te oparte na celach i oparte na wartościach, nie działają zbyt dobrze razem. Oznacza to, że w tym przypadku wydaje się, że jest wszystko w porządku. Po prostu próbuję pokazać Ci jedno ograniczenie, aby tego nie nadużywać. Na przykład teraz mam tutaj jeden stary link, a wewnątrz niego użyję jednego z nowszych opartych na wartościach. Więc to jest szczegół „przejdź do”, powiedzmy B. Niech to będzie 2. Znowu użyję tu liczby całkowitej.

```swift
                Section ("Old"){
                    NavigationLink ("Old link with destination ") {
                        Text("Old navigation link")
                        NavigationLink("Go to 2", value 2)
                    }
                }
```

Okej, teraz jeśli przejdę do tej destynacji, zobaczysz „przejdź do 2”. Przejdź do 2. Teraz pokazuje mi ten sam link, ale dla wartości powinno mi pokazać po prostu szczegóły tej liczby. Nie robi tego, ale jeśli teraz wrócę, pokaże mi właściwe szczegóły. Gdy wrócę, tak więc to po prostu nie działa. Po prostu mówię, nie mieszaj i nie dopasowuj tego zbyt wiele. W zasadzie prawdopodobnie najlepiej jest zapomnieć o tych opartych na destynacjach, ponieważ masz możliwość użycia normalnego przycisku, a to jest po prostu prezentowane tutaj dla rzeczy, które są staroświeckie, powiedzmy. Okej, teraz zróbmy to w odpowiedni sposób, dodając więcej stosów na górę i dla tego muszę coś zmienić w DetailView, ponieważ musimy dodać więcej linków w szczegółach. Więc tutaj mogę wstawić dzielnik, a następnie tworzyć więcej linków nawigacyjnych z tytułami i wartościami. Więc „przejdź do 3”. Może użyjemy dwóch różnych, jeden dla tekstu i jeden dla literki lub wartości ciągu znaków. 

```swift
struct DetailView: View {
    let text: String
    var body: some View {
        VStack {
            Image(systemName: "")
            Text("Detail showing")
            Text(text)
            Divider()
            Section("Links") {
                NavigationLink("Goto detail view 3",value: 3)
                NavigationLink("Goto detail view CCC",value: "CCC")
            }
        }
        .navigationTitle(text)
        .navigationBarTitleDisplayMode(.inline)
    }
}
```

 Muszę wrócić do mojego widoku głównego. I muszę iść do wartości ciągu znaków, więc A. Teraz masz te linki. Jeśli przejdę do drugiego z tekstem. Teraz jest przesuwane coraz wyżej i jeśli wrócisz, zobaczysz, że kolejność nadal jest zachowana. Teraz widziałeś, jak zmienić stos nawigacyjny, aby dodać więcej widoków na górę lub po prostu wrócić za pomocą przycisku powrotu.

![2023-11-08_18-49-27 (1)](2023-11-08_18-49-27%20(1).gif)

W niektórych przypadkach chcesz wykonywać nawigację programistyczną. Na przykład, jeśli chcesz wrócić do widoku głównego, chcesz wrócić bezpośrednio do pierwszego, lub chcesz stosować głębokie odnośniki. Jak zrobić tę nawigację programistyczną? Ważne jest w tym przypadku rzeczywiste uzyskanie właściwości, która definiuje stan nawigacji. A stan lub właściwość, która definiuje ten stan, możemy faktycznie uzyskać dostęp do stosu nawigacji, ponieważ to on śledzi stan i manipuluje stanem. Jeśli chcesz, musisz zapytać ten stos, jaki jest stan. Dużo łatwiej jest uzyskać do niego dostęp ze stosu nawigacji, ponieważ jest to jedno źródło. Jest to jedna jednostka, która obsługuje wszystkie operacje przesuwania i zdejmowania widoków.

Wcześniej musiałem uzyskiwać dostęp do stanu z linków tutaj `NavigationLink(... isActive: ...)` , czy jest aktywny czy nie, lub z wyboru `NavigationLink(... tag: ... selection: ...)`. Co już nie było zbyt wygodne. Dużo bardziej sensowne jest przeniesienie tego do stosu nawigacji. Naprawdę podoba mi się ta zmieniona funkcjonalność. I właściwość, którą musimy przyjrzeć się bliżej, to ta druga tutaj. Więc już miałem widok jako trasę, a druga to ścieżka. Jest to wiązanie z typem nawigacyjnej ścieżki. Tak naprawdę jest to nawigacyjna ścieżka. To jest jak tablica , ponieważ musi mieć sortowanie. Więc musimy mieć przy NavigationStack(path: $path) wiązanie do nawigacyjnej ścieżki. Podobnie jak w moich innych ustawieniach tutaj, mam zamiar utworzyć, więc mam zamiar utworzyć `@State private var path= NavigationPath()`. I możesz po prostu utworzyć nową za pomocą domyślnego inicjalizatora nawigacyjnej ścieżki. I teraz mogę użyć tego wiązania z nią.  Chcę zobaczyć, co jest w tej właściwości „path”. I chciałem to pokazać tutaj na dole w małym widoku, gdzie możemy zobaczyć, jakie właściwości mamy i co możemy manipulować za pomocą tej ścieżki.

Ponieważ muszę to zrobić za każdym razem, gdy nawiguję tutaj. Nie mogę tego umieścić w stosie nawigacji, ponieważ straciłbym to, przemieszczając się do szczegółów. Muszę umieścić to poza stosem nawigacji. Więc zwijam Navigation stack  klikam prawym klawiszem  i wybieram „wbuduj w V stack”. Więc po prostu tworzę kolejny V stack, więc mogę dodać tło, tekst „path”. 

```swift
struct FirstTabView: View {
    ...
    @State private var path = NavigationPath()
    var body: some View {
        VStack {
            NavigationStack (path: $path){
                ...
            }

            VStack {
                Text("Path")
                Text("Number of detail views on stack: \(path.count)")
                Button {
                    path.removeLast()
                } label: {
                    Text("go back one view")
                }
            }
        }
```

 Więc gdy jesteśmy na widoku głównym, nie mamy żadnych widoków szczegółowych. Następnie klikniesz jeden z widoków szczegółowych i zobaczysz, że liczba ta wzrasta do jednego. Teraz możesz przejść do innego. Zwiększa się do dwóch. Okej, ten szczegół nie ma już kolejnych. Muszę użyć jednego z tekstem. Teraz jestem na dwóch. Trzy. Gdy wrócisz, zobaczysz, że ta liczba także maleje. Dzięki temu wiesz, ile widoków jest wewnątrz twojego stosu. Następnie pozostałe są do manipulowania stosami nawigacyjnymi lub ścieżkami. Stworzę tutaj przycisk. Zobaczmy, co ma do zaoferowania właściwość „path”. Tutaj jest napisane „remove last”. Więc podstawowo, gdy usuniesz jeden z tych elementów danych. Co to jest nawigacyjna ścieżka? Jest to kolekcja wszystkich danych reprezentacji w twoim stosie nawigacji. Więc wszystkie te wartości, które tutaj dołączam, są w zasadzie dodawane do mojej nawigacyjnej ścieżki. Ponieważ mam tutaj różne wartości. Mam tutaj liczby całkowite i ciągi znaków. To musi radzić sobie z różnymi typami. A co robimy w Swifcie, gdy mamy do czynienia z różnymi typami? Tworzymy tablice. Więc w zasadzie jest to użycie typu „any” w tej kolekcji.

I jeśli spojrzysz na podsumowanie, mówi, że jest to lista tablic typów danych reprezentujących zawartość stosu nawigacji. To także dlaczego właściwie nie widzimy rzeczywistych wartości w ścieżce, ponieważ są wszystkie typu „any”. Więc nie pozwalają nam na zbyt wiele. Ale dla niektórych powszechnych zadań, ponieważ jest to kolekcja, takie jak usuwanie ostatniego elementu, jest możliwe. Kiedy usuwam ostatni element z danych reprezentujących mój stos, usuwam w zasadzie dane reprezentujące ostatni widok. Usuwam ostatni widok ze stosu. 

![2023-11-08_19-19-21 (1)](2023-11-08_19-19-21%20(1).gif)

Oznacza to, że ta akcja powoduje cofnięcie się o jeden widok. Okej, spróbujmy tego. Nawigujmy trochę głębiej, na dwa poziomy, i teraz mogę powiedzieć „cofnij o jeden widok”. I rzeczywiście cofam się. Jest to ta sama akcja, co gdybym nacisnął przycisk wstecz tutaj. Tak więc moglibyśmy użyć tego do tworzenia własnych niestandardowych przycisków powrotu, jeśli chcemy. Jak to zrobić? W widoku szczegółów możemy powiedzieć „navigation back button hidden”, „navigation bar back button hidden”. Teraz są naprawdę długie. Teraz ukrywam przycisk wstecz, i mamy teraz możliwość dołączenia własnego w pasku narzędzi. Więc to jest modyfikator paska narzędzi, a chcę po prostu mieć element paska narzędzi z umiejscowieniem. Mam tylko jeden, dlatego to jest element, nie grupa, z „navigation bar leading”. I teraz tutaj mogę stworzyć swój własny przycisk powrotu. Powiedzmy, że chcę mieć domyślny obraz systemowy. Więc domyślnie używa tego. Powiedzmy, że użyję tego z okręgiem. Tak więc widzimy różnicę, co oznacza, że muszę użyć obrazu dla „system name” i następnie użyć tej wartości tekstowej.

```swift
import SwiftUI

struct DetailView: View {
    let text: String
    @Binding var path: NavigationPath
    var body: some View {

        VStack {
            Image(systemName: "")
            Text("Detail showing")
            Text(text)
            Divider()
            Section("Links") {

                NavigationLink("Goto detail view 3",value: 3)

                NavigationLink("Goto detail view CCC",value: "CCC")
            }
        }
        .navigationTitle(text)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    path.removeLast()
                } label : {
                    Image(systemName: "chevron.left.circle")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(text: "AAA BBB CCCC",path: .constant(NavigationPath()))
    }
}
```

Okej, to nie jest widoczne podczas podglądu. Owinąłem to teraz w stos nawigacji. 

```swift
                .navigationDestination(for: String.self) { textValue in
                    //Text("detail with value: \(textValue)")
                    DetailView(text: textValue, path: $path)
                }
```

dodajmy teraz przycisk w tabView1 ktory dod nam cos do tej ścieżki: 

```swift
            VStack {
                Text("Path")
                Text("Number of detail views on stack: \(path.count)")
                Button {
                    path.removeLast()
                } label: {
                    Text("go back one view")
                }
                Button {
                    path.append("GGG")
                } label: {
                    Text("go to GGG")
                }
            }
```





Teraz możesz przypiąć to ulubione, które jest tą wartością GGG. Możesz to zrobić w dowolnym miejscu na stosie. Możesz teraz to przypiąć i widzisz, że przypiąłem to GGG. Tak więc to programowo tworzy połączenie. 

Z dowolnego miesjca moge wrócić do pierszego okna czyszcząc  zmienna path: 

```swift
                Button {
                    path = NavigationPath()
                } label: {
                    Text("go to root view")
                } 
```

Czasami warto uruchamiać to na symulatorze, a nie tylko w podglądzie, ale w tym przypadku jest tak samo. Okej, teraz zobaczyliśmy wszystkie manipulacje naszą małą ścieżką nawigacji, która jest kolekcją wszystkich danych. Jak dotychczasowe podsumowanie, w tych stosach nawigacji dodajemy widoki, mamy jeden widok główny i dodajemy coraz to nowe widoki szczegółowe na wierzch. Aby dodać te widoki, używam nawigacyjnego linku z wartością, czyli te pomarańczowe strzałki, to jest właśnie to, co robię, używając nawigacyjnego linku z wartością, czyli faktyczny widok szczegółowy. Żółty kolor jest nadawany przez modyfikator nawigacyjnego celu. Jeśli chcę pokazać różne widoki szczegółowe, muszę tworzyć różne modyfikatory nawigacyjnego celu z różnymi typami. Wszystkie te nawigacje działają na wartościach lub typach wartości i ich typach, ponieważ zawsze mapuję odpowiednie typy razem. Każdy z tych nawigacyjnych linków z jego wartością pasuje do jednego nawigacyjnego celu z odpowiadającą wartością. Aby działać z wieloma typami, możemy użyć tej nawigacyjnej ścieżki, która jest kolekcją wyzerowanych typów. Ponieważ to jest kolekcja, podkreślam to, ponieważ zawsze byłem zdezorientowany co do nawigacyjnej ścieżki, co to jest, ale to jest inna kolekcja, podobna do tablicy. Jeśli chcesz używać tablicy `Any`, to możesz bezpośrednio użyć nawigacyjnej ścieżki. Jeśli masz jeden typ, możesz po prostu użyć tego samego typu.

## Nistandardowe typy

Pierwszą rzeczą, którą muszę zrobić, aby pracować z niestandardowym typem, jest oczywiście utworzenie niestandardowego typu. Używam innego folderu na to, ponieważ chcę później dodać więcej. To nie będzie bardzo skomplikowany model. Powiedzmy, że mam typ książki. Jest to plik Swift o nazwie `book`. Jest to typ danych, więc musi to być struktura `Book`.

```swift
import Foundation

struct Book: Identifiable {
    let id: UUID
    var title: String

    init(title: String) {
        self.id = UUID()
        self.title = title
    }
    static func examples() -> [Book] {
        [
            Book(title: "Pan Tadeusz"),
            Book(title: "Solaris"),
            Book(title: "Eden"),
            Book(title: "Cesarz"),
            Book(title: "Heban"),
        ]
    }
}
```





I jedną właściwość, którą teraz upraszczam, to nazwa książki. Jest to typ `String` lub tytuł tej książki, ponieważ mam zamiar pokazać listę książek, a dla każdej z nich będę używać `Identifiable`, co oznacza, że muszę mieć identyfikator. Dlatego mam stałą `let ID: UUID`, i tworzę inicjalizator, w którym domyślnie ustawiam UUID. Teraz tworzę małą funkcję, która tworzy kilka przykładowych książek szczegółowych. Jest to funkcja statyczna `examples`, która zwraca tablicę książek, i tworzę tu kilka książek o różnych tytułach.



​	 Okej, teraz przejdźmy do stworzenia naszej drugiej karty, gdzie możemy użyć tego niestandardowego typu. Więc w tej drugiej grupie kart tworzę widok SwiftUI o nazwie `SecondTabView`. Po pierwsze, muszę właściwie mieć moje książki do pokazania. Tak więc to są książki. To jest wszystko statyczne. To są nie tylko domyślne wartości, które używam. Jest to tablica moich książek. 

```swift
let books = Book.examples()
```

Drugą właściwością, którą chcę sprawdzić, była ścieżka stosu nawigacyjnego. Jak widziałeś, musimy utworzyć właściwość stanu. Więc jest to `@State private var path`. Znowu moglibyśmy użyć `navigation path`, ale ponieważ używam tylko jednego typu, nie muszę tutaj używać tej kolekcji z wyzerowanym typem, mogę użyć bezpośrednio kolekcji, która przechowuje ten typ. Tak więc jest to tablica książek, i na początku nie mam wybranego widoku, więc jest to pusta tablica. Może zmienię to na `bookPath`, to jest właściwie ścieżka wybranej książki. Albo można powiedzieć `selectedBooks`, przypuszczam. W treści wracam do mojego stosu nawigacyjnego z `path` i `route`.

Tak więc teraz moją wybraną ścieżką książki jest `selectedBookPath`, a tutaj mogę pokazać listę dla każdej z moich książek. Dla każdej z moich książek pokazuję nawigacyjne łącze z wartością "title" i wartością "books.title", a wartość to sama książka. 

```swift
struct SecondViewTab: View {
    let books = Book.examples()
    @State private var path = NavigationPath() // [Book]()
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(books) { book in
                    NavigationLink(book.title,value:book)
                }
            }
        }
    }
}

#Preview {
    SecondViewTab()
}
```

 Nawigacyjne łącze faktycznie daje ci właściwe informacje. Tutaj mówi, że wymaga, aby `Book` zgodny był z `Hashable`. *Wróć do `Book` i dodaj zgodność z `Hashable`. Jest automatycznie zgodny z `Hashable`, ponieważ wartości wewnątrz są zgodne z `Hashable`.* Teraz wróć do mojego widoku drugiej karty i błędy znikają. Teraz mam moją listę bez linków, ponieważ jeszcze nie zdefiniowałem destynacji. Więc stwórzmy nowy widok z `BookDetailView`. To po prostu przyjmuje książkę i dodaję przykład w podglądzie. 

```swift
import SwiftUI

struct BookDetailView: View {
    let book: Book
    var body: some View {
        VStack {
            Text(book.title)
            Divider()
            ForEach(1...4, id: \.self) { id in
                NavigationLink("suggestion \(id)", value: Book(title: "suggestion no \(id)"))
            }
        }
        .navigationTitle("Book detail view")
    }
}

#Preview {
    BookDetailView(book: Book(title: "Jebać PiS"))
}
```

Okej, to co będziemy pokazywać, to po prostu `VStack`, który mówi "widok szczegółowy książki", a jako tytuł nawigacji będę używać tytułu książki i ponieważ chcę używać stosu z więcej widokami wewnątrz, muszę tutaj dodać więcej linków. Więc dodaję tu separator i po prostu kilka nawigacyjnych linków z tą wartością opartą na sugestii "one", a wartość musi być tytułem książki, i używam tutaj tej samej nazwy sugestii. Okej, zobaczmy, jak to działa razem, wracając do widoku drugiej karty. Teraz nadal muszę faktycznie przypiąć moją docelową destynację nawigacji, dla `Book.self` `book`, a tutaj to jest mój widok szczegółowy dla tej książki.

```swift
List {...}          
.navigationDestination(for: Book.self) { book in
                BookDetailView(book: book)
}
```

 Teraz powinna działać nawigacja, i mogę przechodzić do różnych widoków szczegółowych. Chcę ci jeszcze pokazać, jak buduje się stos. Więc umieśćmy to poniżej, na zewnątrz mojego stosu nawigacyjnego. Opcja + kliknij na nawigacji, polecenie + kliknij na nawigacji, osadź w `VStack`.



To jest `VStack` dla każdej z moich wybranych ścieżek książki. Teraz pokazuje mi książkę, a ja pokazuję tutaj tytuł książki. Okej, teraz kiedy tutaj kliknę, widzisz, że mam wybraną. Zaleta polega teraz na tym, że widzisz wszystkie wartości, które są w twoim stosie nawigacyjnym. Więc jeśli na przykład chcesz wrócić do określonej wartości, masz teraz tę możliwość. Na przykład mogę zresetować całą ścieżkę do pierwszej. Wystarczy, że uzyskam pierwszą wartość, w przeciwnym razie zwróć, a teraz mogę ustawić tę książkę. I potem przejdź do ulubionych i wróci na pierwszą kartę. Możesz także, ponieważ masz całą tablicę książek, możesz przeszukać tę tablicę i usunąć wszystkie, które są za nią na górze, aż dojdziesz do tej pozycji. Ale jak widziałeś, to już robi doskonale. Głównym punktem było naprawdę to, że widzisz, że ta ścieżka lub ta ścieżka nawigacyjna to nic specjalnego. Możesz używać jej zarówno z wygaszaniem typu `navigation path`, jak i z własnym typem niestandardowym, co prawdopodobnie jest łatwiejsze, ponieważ wtedy naprawdę wiesz, co robisz. Teraz chcę przejść do bardziej złożonego przykładu, ponieważ liczby i ciągi znaków były prawdopodobnie mniej interesujące. Powiedzmy, że mam tutaj trzy różne sekcje: książki, filmy i piosenki, i chcę umieszczać na wierzchu różne rodzaje rzeczy. Więc mam trzy różne szczegóły i mogę je po prostu nakładać jeden na drugi. Zróbmy to na trzeciej karcie. To jest nowy plik, widok SwiftUI: `ThirdTabView`. Jak już powiedziałem, chcę mieć trzy różne typy, więc szybko tworzę jeszcze dwa typy dla piosenki i filmu. Ponownie mój film ma tylko jedną właściwość, która jest tytułem. Musi być identyfikowalny i zgodny z `Hashable`, ponieważ chcemy go użyć z `navigation path`. A potem mam trzy przykłady. Dla mojej piosenki mam więcej wartości. Nie musimy ich naprawdę używać. Więc mamy tytuł, artystę i rok. Znowu musi być identyfikowalny i zgodny z `Hashable`. A potem dla wygody mam tutaj te dane przykładowe.

> Now in my view because I want to show here a list of all of these and I want to create more deeper linking. I'm just going to create one observable object that loads all this that holds all this data. So this is a SwiftUI file. It's an observable object class. So this is model data manager. It could be like a get where you would get the data from the internet or some stuff or load it from the file system. So this is class model data manager conforming to observable object. And I need to have this three arrays data types at published var books. This is for now my examples. And the same is for song and movie. Now when I'm in my photo tab view I need this data. So I'm creating an instance of my view model at state object of our model data and I'm creating one of these instances. Now I have all the data and we want to use a navigation stack view with path and route. So the path maybe I just leave out the path so we can discuss this in a little while. So here I need to create my route view with the list of all these entities. So let's say this is my route view and it needs to have all the data. So it has to have a observe object var model data of type model data manager. And the same is true for the initializer. So we can create this for convenience. I'm just going to create here a list with three sections. So this is section title songs for each of my model data's songs. And I want to show a navigation link with the value. So showing these songs title and the values the song. So then two more one more section for movie. And for each of these movies I show a link title and value 15 movies title and the value is the movie itself. And then another section for book. Where I show the books. And for each of these books I again show a navigation link title and value the books title and the value is the book itself. OK this looks quite nice and I can use this route view in my third tab. So this is the route view and it needs to have this data. Maybe I'm going to add a title to the route view. 
>

Teraz w moim widoku, ponieważ chcę tu pokazać listę wszystkich tych danych i chcę tworzyć głębsze połączenia, po prostu utworzę jeden obiekt obserwowalny, który wczytuje wszystkie te dane. Więc to jest plik SwiftUI. Jest to klasa obiektu obserwowalnego. To jest `ModelDataManager`. Mogłoby to być jakieś pobranie, z którego uzyskałbyś dane z internetu lub coś podobnego, albo pobranie ich z systemu plików. Tak więc to jest klasa `ModelDataManager`, zgodna z `ObservableObject`. I muszę mieć te trzy tablice typów danych jako `@Published var books`. Na razie to są moje przykłady. I to samo dla piosenek i filmów. Teraz, kiedy jestem w moim widoku karty trzeciej, potrzebuję tych danych. Więc tworzę instancję mojego widoku modelu jako `@StateObject` naszego `ModelDataManager` i tworzę jedną z tych instancji. Teraz mam wszystkie dane i chcemy użyć nawigacyjnego widoku stosu z `path` i `route`. Więc może po prostu pominiemy `path`, abyśmy mogli to omówić za chwilę. Tak więc tutaj muszę stworzyć mój widok `route` z listą wszystkich tych encji. Więc powiedzmy, że to jest mój widok `route`, i musi mieć wszystkie dane. Musi mieć obserwowalny obiekt `var modelData` typu `ModelDataManager`. I to samo dotyczy inicjalizatora. Możemy to zrobić dla wygody. Po prostu tworzę tutaj listę z trzema sekcjami. Więc jest to sekcja tytułowa "songs" dla każdej z piosenek w moim `modelData`. I chcę pokazać nawigacyjne łącze z wartością, więc pokazuję tytuły tych piosenek i wartość to piosenka. Potem jeszcze jedna sekcja dla filmów. Dla każdego z tych filmów pokazuję tytuł i wartość, czyli 15 tytułów filmów, a wartość to sam film. I kolejna sekcja dla książek, gdzie pokazuję książki. Dla każdej z tych książek znów pokazuję nawigacyjne łącze, tytuł i wartość, czyli tytuł książki i wartość to sama książka. Okej, wygląda to dość dobrze, i mogę użyć tego widoku `route` w mojej trzeciej karcie. Więc to jest widok `route`, i musi mieć te dane. Być może dodam tytuł do widoku `route`.

> So outside of the list I'm going to create a navigation title route view. Now I have my three sections but no detail views attached. So again I need to have here my navigation destinations for value. So I had one for book and I can show the book detail view. So tapping on one of these books gets me there. Before I continue with the other ones. Because I would have a different type here instead of using because now we are basically for a path using a navigation path with this type erasing. How can we create another way of not getting this type erasing. And that is by creating a super model not a model that encapsulates all the other models. And in this case because I have three or three sections it's an enum. So I'm for now placing this here. So this is my selection state. The three cases. This is movie song and book and each of these cases actually has an associated value. If I'm in the movie section I actually have a movie that I want to attach. So this is movie or song or book. You can also have a case of settings. Actually didn't use this maybe I can. And the root view add another button or actually it's a navigation link. So this is settings and the value because previously we had this problem of settings doesn't have a value. I don't have anything that I want to pass but because I'm changing to my own custom type is the selection type. I'm passing the selection states settings value here and it actually already tells me that I have to make this hashable. So let's add conformance to hashable. So my root view. 
>

Poza listą tworzę teraz nawigacyjny tytuł, który to jest widok `route`. Teraz mam moje trzy sekcje, ale nie mam do nich przypisanych widoków szczegółowych. Znowu muszę mieć swoje destynacje nawigacji dla wartości. Więc mam jedną dla książki i mogę pokazać widok szczegółowy książki. Tak więc kliknięcie na jednej z tych książek przenosi mnie tam. Zanim przejdę do pozostałych, ponieważ miałbym tutaj inny typ, zamiast korzystania, ponieważ teraz używamy nawigacyjnej ścieżki z tym wygaszaniem typu. Jak możemy stworzyć inny sposób, aby tego nie używać? I to można zrobić, tworząc supermodel, nie model, który enkapsuluje wszystkie inne modele. W tym przypadku, ponieważ mam trzy sekcje, jest to enum. Na razie umieszczam to tutaj. Tak więc to jest mój stan wyboru. Trzy przypadki: film, piosenka i książka, a każdy z tych przypadków ma właściwie powiązaną wartość. Jeśli jestem w sekcji filmów, mam rzeczywiście film, który chcę przypisać. Więc jest to `Movie`, `Song` lub `Book`. Możesz także mieć przypadek `Settings`. Tak naprawdę go nie użyłem, ale może mogę go użyć. W widoku `route` dodaję kolejny przycisk lub właściwie to jest nawigacyjne łącze. Tak więc to są ustawienia, a wartość, ponieważ wcześniej mieliśmy ten problem z ustawieniami, które nie mają wartości. Nie mam nic, co chcę przekazać, ale ponieważ zmieniam to na swój własny niestandardowy typ, jest to typ wyboru, przekazuję tutaj wartość ustawień w przypadku `selection`. Faktycznie już mówi mi, że muszę zrobić to zgodne z `Hashable`. Dodajmy więc zgodność z `Hashable`. Tak więc mój widok `route`.

> This is now not complaining anymore and I have here my nice settings button because I want to change use this kind of navigation now. Also my values have to change. So books become navigation states books with this book encapsulated movie with this movie encapsulated and song case with this song attached. Okay now going back to my third tab view the destinations if I want to use these ones now have to be changed because now it doesn't work anymore. So I have to go for navigation state. Now this is not a book anymore it's the state and because it's enum I can use a switch case switch state case.song let song case.movie let movie case.book let book and case.settings. I don't have any views a detail views for this. I could use one of these. I need to create here detail views for song movie and settings. So let's just quickly create them. Song detail view. If you don't want to do this yourself you can just use the examples that I created and use the files from my github repository. Okay now I have this song detail view. Then a settings view. Adjust to settings. I could use the book destination view for the detail but here the value is book type and I want to use a different one. So let's just create another book detail view. Actually I probably should rename this one. So we can basically use everything the same except the value needs to be now my selection state for book and then giving whatever book I want to show here. Okay it's still not building because my root view because my third tab view is broken. Okay let's just add here my song detail view for song my movie my book detail view and my settings view and I forgot to add a movie detail view. So I'm going to create another one. Probably should have added all the movie details before I change something. Okay just showing here what view we have the detail for movie and the movie's title. Now I have all my detail views. So this is the movie detail view for movie. 
>

Teraz nie ma już żadnych skarg, i mam tu ładny przycisk ustawień, ponieważ chcę teraz użyć tego rodzaju nawigacji. Moje wartości też muszą się zmienić. Tak więc książki stają się stanami nawigacji `navigation states`, z tą książką enkapsulowaną, film z tym filmem enkapsulowanym, a piosenka z tą piosenką przypisaną. Okej, teraz wracając do mojego widoku trzeciej karty, destynacje, jeśli chcę teraz używać tych, muszą zostać zmienione, ponieważ teraz to już nie działa. Więc muszę teraz używać `navigation state`. Teraz to już nie jest książka, to jest stan, a ponieważ to jest enum, mogę użyć switch case. Tak więc dla `state` mam `case.song` i przypisuję to do `let song`, dla `case.movie` mam `let movie`, dla `case.book` mam `let book`, a dla `case.settings` nie mam żadnych widoków szczegółowych. Mogę użyć jednego z tych. Muszę jednak stworzyć widoki szczegółowe dla piosenki, filmu i ustawień. Więc po prostu szybko je stworzę. Widok szczegółowy piosenki. Jeśli nie chcesz tego robić samodzielnie, możesz po prostu użyć przykładów, które stworzyłem, i użyć plików z mojego repozytorium na GitHubie. Okej, teraz mam ten widok szczegółowy piosenki. Potem widok ustawień. Po prostu ustawienia. Mogłem użyć widoku destynacji książki dla szczegółów, ale tutaj wartość to typ książki, a chcę użyć innego. Więc po prostu stwórzmy inny widok szczegółowy książki. Właściwie prawdopodobnie powinienem zmienić nazwę tego. Więc możemy zasadniczo używać wszystkiego takiego samego, z wyjątkiem tego, że wartość teraz musi być moim stanem wyboru dla książki i przypisaniem dowolnej książki, którą chcę tutaj pokazać. Okej, nadal nie buduje się, ponieważ mój widok główny, ponieważ mój widok karty trzeciej jest zepsuty. Okej, po prostu dodajmy tutaj mój widok szczegółowy piosenki dla piosenki, mój widok szczegółowy filmu, mój widok szczegółowy książki i mój widok ustawień, i zapomniałem dodać widok szczegółowy dla filmu. Więc stworzę kolejny. Prawdopodobnie powinienem był dodać wszystkie szczegóły filmu przed zmianą czegokolwiek. Okej, po prostu pokazuję tutaj, jakie widoki mamy, szczegóły dla filmu i tytuł filmu. Teraz mam wszystkie moje widoki szczegółowe. Więc to jest widok szczegółowy filmu dla filmu.

> So this already looks nice and clean because here I have this navigation stick and one root view. So this is the main view you see on the right and I have separately now the definition or set what detail views I want to show. So one advantage of this navigation destination modifier much more clean and organized. Maybe I'm going to well maybe you should I should change the settings to put it up here with this gear icon. You can try and all of them are working. All right no I didn't. I only added more details for the book suggestion. You could also add more links for let's say songs and in this case I probably should just use this the data that I have here my model manager. So in the song detail view I can also add a divider text something like people also liked and now I want to show some of the list of all the other songs. OK I only have three. You could probably fetch different ones. They are on my model here and I want to simply because I probably need them everywhere prefer to have this in the environment. So this is environment object model manager and now I can use this in my song detail. So by accessing it from the environment object var model data this is of type model manager. Preview will crash unless I add an instance of this type model manager as all the data. And now I can use here for each of my model data songs. You could also link different things. So adding here navigation link with value and title so song for example if you want to have different ones add a song icon. 
>

To już wygląda ładnie i czysto, ponieważ mam tutaj ten stos nawigacyjny i jeden widok główny. Tak więc jest to główny widok, który widzisz po prawej stronie, a ja mam teraz osobno definicję lub zestaw widoków szczegółowych, które chcę pokazać. Jedną z zalet tego modyfikatora nawigacji jest znacznie czystsze i zorganizowane. Być może powinienem przenieść ustawienia tutaj i umieścić je z ikoną zębatki. Możesz to wypróbować, wszystkie działają. Okej, nie dodaję więcej informacji. Dodano więcej informacji tylko dla sugestii książki. Możesz również dodać więcej linków dla na przykład piosenek, a w tym przypadku prawdopodobnie powinieneś po prostu użyć danych, które mam tutaj w moim menedżerze modeli. Więc w widoku szczegółowym dla piosenki mogę dodać podział i tekst, na przykład "Inni też polubili", i teraz chcę pokazać listę wszystkich innych piosenek. Okej, mam tylko trzy. Prawdopodobnie możesz pobrać różne. Są w moim modelu tutaj, i chcę to po prostu, ponieważ prawdopodobnie będę ich potrzebował wszędzie, dodać do środowiska. Więc to jest `environmentObject modelManager`, a teraz mogę to użyć w moim widoku szczegółowym dla piosenki. Tak więc, dostęp do niego z obiektu środowiskowego `var modelData`, jest to typ `modelManager`. Podgląd będzie się zawieszał, chyba że dodam instancję tego typu `modelManager` jako wszystkie dane. I teraz mogę użyć tutaj dla każdej z moich piosenek z `modelData songs`. Można również podlinkować różne rzeczy. Dodawanie tutaj nawigacyjnego łącza z wartością i tytułem, na przykład piosenka, jeśli chcesz mieć różne, dodaj ikonę piosenki.

> Oh yeah music. This is a label with the song's title and the system image is the note. Probably put this in a VStack with leading alignment and noted the title together. Okay now we have a little bit more navigation building up. OK we have a crash. So this kind of things don't usually work very well. I'm actually I mean kind of on purpose showed you this. So in order to run this in the simulator I actually need to add this to the simulator. I didn't do that so far. So in my content view I will now add this tab view that I was talking about all the time and never actually did. So I want to have my first tab view my second tab view and my third tab view. And then adding here tab items. Just with a random icon. Same for the other two. OK this is the typical way of using this. OK finally let's run this. Go to my third tab press on one of the songs. OK. Fatal error. Good. This is now the information. This is much. This gives me actually some information what I did wrong. So the environment model model data manager was not found. So my song detail view doesn't have this in the environment. Now I'm going to check where I created an instance of my song detail view. This was in the third tab view here and it's the navigation destination song detail view. I did add this environment object afterwards thinking probably getting it everywhere but it doesn't. You need to if you put it afterwards it just doesn't get it. So just a little hint for the navigation destination modifier. You need to attach this here too. So let's just create a group because I need to do this. Probably more common to add this to all views that are in there. 
>

Oh tak, muzyka. To jest etykieta z tytułem piosenki, a obraz systemowy to nuta. Prawdopodobnie umieść to w `VStack` z wiodącym wyrównaniem i połącz tytuł z nutą. Okej, teraz mamy trochę więcej nawigacji. Okej, mamy awarię. Takie rzeczy zwykle nie działają bardzo dobrze. Właściwie celowo to pokazałem. Aby uruchomić to w symulatorze, muszę to faktycznie dodać do symulatora. Nie zrobiłem tego do tej pory. Więc w moim widoku zawartości teraz dodam ten widok karty o którym cały czas mówiłem, ale nigdy go faktycznie nie utworzyłem. Więc chcę mieć mój pierwszy widok karty, mój drugi widok karty i mój trzeci widok karty. A potem dodaję tutaj elementy karty. Po prostu z losową ikoną. To samo dla pozostałych dwóch. Okej, to jest typowy sposób użycia tego. Okej, w końcu uruchommy to. Przejdźmy do mojej trzeciej karty, kliknijmy na jedną z piosenek. Okej. Błąd krytyczny. Dobrze. Teraz mam informacje. To daje mi właściwie jakieś informacje o tym, co zrobiłem źle. Więc model środowiska `modelDataManager` nie został znaleziony. Więc mój widok szczegółowy dla piosenki nie ma tego w środowisku. Teraz sprawdzę, gdzie utworzyłem instancję mojego widoku szczegółowego dla piosenki. Było to w moim widoku trzeciej karty tutaj, a jest to destynacja nawigacji `songDetailView`. Później dodałem to `environmentObject`, myśląc, że prawdopodobnie dostanę to wszędzie, ale nie dostanę. Jeśli dodasz to później, po prostu tego nie dostajesz. Więc mała wskazówka dotycząca modyfikatora nawigacji. Musisz to tutaj również dołączyć. Więc po prostu stwórzmy grupę, ponieważ muszę to zrobić. Prawdopodobnie bardziej powszechne jest dodanie tego do wszystkich widoków, które są tam zawarte.

> OK so I'm wrapping my switch case here in a group. So this view modifier is then added to all of my views inside. It hopefully means that everything is working now. Go to my third tab. And yes we have the detail and I actually see all the songs. Does not work. OK. At least now the information seems to be useful. A link is presenting a value of type song but there is no matching navigation destination declared visible for the location of the link. And also tells you how they are actually looking for this navigation destination things. So they're first looking in the surrounding navigation stack. So they're going the view tree up and if they don't find anything there they are looking in the navigation split view. This is possible you can stack them inside of each other. OK let's see what I did in the song detail view. Ah yeah actually I used the song value not my new selection value. So thank you for the very informative help. Not this weird you have to interpret language. I mean this was in a very clear language. Nice nice. Let me try again. OK now everything seems to work. OK so make sure you are putting it. You need to add all the environment objects again in the navigation destinations. I'm not even sure if it's the environment values too. Like if you change the environment value for color scheme. 
>

Dobrze, więc owijam moje `switch case` tutaj w grupę. Więc ten modyfikator widoku jest dodawany do wszystkich moich widoków wewnątrz niego. Mam nadzieję, że teraz wszystko działa. Przejdźmy do mojej trzeciej karty. I tak, mamy szczegóły i widzę wszystkie piosenki. Nie działa. Okej, przynajmniej teraz informacje wydają się być przydatne. Łącze prezentuje wartość typu piosenka, ale nie ma zadeklarowanej odpowiadającej mu widocznej destynacji nawigacji. I mówią ci także, jak właściwie szukają tych destynacji nawigacji. Najpierw sprawdzają otaczający stos nawigacyjny. Idą w górę drzewa widoku i jeśli tam nic nie znajdą, sprawdzają podział nawigacji. Jest to możliwe, możesz je układać jedno wewnątrz drugiego. Okej, zobaczmy, co zrobiłem w widoku szczegółowym dla piosenki. Ah tak, rzeczywiście użyłem wartości `song`, a nie mojej nowej wartości wyboru. Więc dziękuję za bardzo pouczającą pomoc. Nie to dziwne, trzeba interpretować jakąś dziwną mowę. Chodzi mi o to, że to było w bardzo czytelny sposób wyjaśnione. Ładnie, ładnie. Spróbujmy jeszcze raz. Okej, teraz wszystko wydaje się działać. Okej, więc upewnij się, że dodajesz wszystkie obiekty środowiska ponownie w destynacjach nawigacji. Nawet nie jestem pewien, czy to także dotyczy wartości środowiskowych, na przykład dla schematu kolorów.

> Dark. OK this is dark. OK yeah it's the same for all the color colors and stuff. Not really sure this is kind of annoying. Maybe if I put it outside. OK so you have to put it outside of the stack. And let's see if this is also working for the navigation state for environment objects. Yes. So really make sure where you put the environment properties at the most highest level around the navigation stack. So all of the elements get this. And now I can actually remove the group again. So it's much more clean and I don't need to add this multiple times. Adding the programmatic navigation again. I would need to go here and access my path property because I want to handle this downwards to all my detail views and I don't really want to you know pass this manually with bindings everywhere. I will use the same trick of a observable object and then adding it in the environment which means I need to create another view model for the navigation state. And this is the fifth file. It's always difficult to name this navigation. Navigation state manager. I probably have to rename stuff. And if you want you can also create another for your view models here. So this is a class conforming to observable object and the property that I want to store is actually defined with the selection state. So I'm also moving it over there or maybe in a separate file. So here it's published for selection path and this is now an array of I mean it's a collection or the path is a collection of my states and they're all represented by the same type which is my selection state. So this is it. And now I can use this here again as a state object of our navigation state manager. Navigation state manager instance and I can give a binding in my navigation stack to my navigation state managers selection path. Okay same I wanted to add this here in the environment. 

Ciemny. Okej, to jest ciemny. Okej, tak samo jest z wszystkimi kolorami i innymi rzeczami. Nie jestem pewien, czy to jest irytujące. Być może, jeśli umieściłbym to na zewnątrz. Okej, więc musisz umieścić to na zewnątrz stosu. Zobaczmy, czy to działa również dla stanu nawigacji dla obiektów środowiska. Tak, naprawdę upewnij się, gdzie umieszczasz właściwości środowiska, na najwyższym poziomie, wokół stosu nawigacji. W ten sposób wszystkie elementy je dostają. I teraz mogę rzeczywiście usunąć grupę ponownie. Jest znacznie czystsze i nie muszę dodawać tego wielokrotnie. Ponowne dodawanie nawigacji programowej. Musiałbym teraz przejść tutaj i uzyskać dostęp do mojej właściwości `path`, ponieważ chcę to przekazać w dół do wszystkich moich widoków szczegółowych i naprawdę nie chcę przekazywać tego ręcznie związując wszędzie. Będę używał tego samego triku z obiektem obserwowanym i następnie dodam to do środowiska, co oznacza, że muszę utworzyć inny widok modelu dla stanu nawigacji. I jest to piąty plik. Zawsze trudno nazwać to nawigacja. Menedżer stanu nawigacji. Prawdopodobnie muszę zmienić nazwy rzeczy. I jeśli chcesz, możesz również utworzyć kolejne dla swoich widoków modeli tutaj. Więc jest to klasa spełniająca protokół `ObservableObject` i właściwość, którą chcę przechowywać, jest faktycznie zdefiniowana jako stan wyboru. Więc również przenoszę to tam lub może do osobnego pliku. Więc tutaj jest to opublikowane dla `selectionPath`, a teraz jest to tablica, chociaż to jest kolekcja, a ścieżka jest kolekcją moich stanów i są one reprezentowane przez ten sam typ, którym jest mój stan wyboru. To tyle. I teraz mogę tego użyć ponownie jako `stateObject` naszego menedżera stanu nawigacji. Instancja `navigationStateManager` i mogę przekazać powiązanie w moim stosie nawigacji do `selectionPath` mojego menedżera stanu nawigacji. Tak samo chciałem to dodać tutaj do środowiska.

> So I add the environment object for navigation state manager and now we can use this anywhere in one of our detail views. So here in the song detail view I can add another button. Okay first I actually need to grab this environment object. Environment object var navigation of type navigation state manager and don't forget to add this to the preview. Okay so a text. This is for example interesting for go to route or if you're done or something. Now we could use the navigation state manager and manipulate the selected selection path directly. But because this is probably an action that I would perform a lot and I don't always remember how I'm supposed to do this. You can create your little functions like up to route. So doing this is basically resetting this whole array. So I'm just throwing away all the detail information by resetting this to an empty array. And now my detail becomes a pop to route function. Okay let's try this in the third tab. I go to one of my details and now I can press you go to route and we are going back to the route view. We can also use this for deep linking. Let's say we have here a small button for settings that will bring us into the settings view. Okay maybe I'm starting to get a little bit crowded in this view. But let's add here a toolbar and I don't want to have this placement and visibility. I mean the placement you can also put on the bottom bar. This is new toolbar. No that was not what I wanted. As the icon I'm using here gear. Okay and I need to embed this actually navigation stack. So you have something in the preview. Okay now we have I have this icon there. Okay one of the things is this toolbar is always like where is it going. You could use the navigation bar trailing. This is not working for macOS.

Więc dodaję obiekt środowiska dla menedżera stanu nawigacji, a teraz możemy używać tego wszędzie w jednym z naszych widoków szczegółowych. Więc tutaj w widoku szczegółowym dla piosenki mogę dodać kolejny przycisk. Okej, najpierw muszę faktycznie pobrać ten obiekt środowiska. Obiekt środowiska `var navigation` typu `navigation state manager` i nie zapomnij dodać tego do podglądu. Okej, więc tekst. Jest to na przykład interesujące dla "go to route" lub jeśli skończyłeś lub coś w tym stylu. Teraz moglibyśmy użyć menedżera stanu nawigacji i manipulować bezpośrednio ścieżką wyboru. Ale ponieważ jest to prawdopodobnie działanie, które chciałbym wykonywać często i nie zawsze pamiętam, jak powinienem to zrobić. Można tworzyć swoje małe funkcje, takie jak "go to route". Więc robienie tego to właściwie resetowanie całej tej tablicy. Więc po prostu odrzucam wszystkie informacje o szczegółach, resetując to do pustej tablicy. I teraz mój przycisk "szczegóły" staje się funkcją "pop to route". Okej, spróbujmy tego na trzeciej karcie. Przechodzę do jednego ze swoich szczegółów i teraz mogę nacisnąć "go to route" i wracamy do widoku trasy. Możemy również używać tego do głębokich odnośników. Powiedzmy, że mamy tutaj mały przycisk dla ustawień, który przeniesie nas do widoku ustawień. Okej, może zaczynam się troszkę gubić w tym widoku. Ale dodajmy tutaj pasek narzędzi i nie chcę mieć tego ustawienia widoczności. Oznacza to, że możesz także umieścić go na pasku dolnym. To jest nowy pasek narzędzi. Nie, to nie było to, co chciałem. Jako ikony używam tutaj koła zębatego. Okej, i muszę właściwie osadzić ten stos nawigacyjny. Tak, żebyś miał coś w podglądzie. Okej, teraz mam tę ikonę tam. Okej, jedną z rzeczy jest to, że ten pasek narzędzi jest zawsze taki... gdzie jest? Możesz użyć paska nawigacyjnego `trailing`. To nie działa dla macOS.

>  Primary action. Okay it's on the right side and now I can say if I mean if I press on this gear icon I actually want to change my navigation state to go to the settings view. Okay maybe let's create another function for this. So what do we want to do? Function go to settings. So my selection path has to change and I don't want to push it on top. So I could if you want to push it on top I would append this new element but I actually want to replace the whole path. We have the selection state dot settings. So now here I can say go to settings. Okay let's try this. I go here and I press on my gear icon. And we are in the settings view. Unfortunately you see okay maybe you don't see it but there is still some remaining thing that I don't like which is this fight which is the title for my previous one. Try again. So if you select the title view you have the navigation title from the song view and now I press on the settings. It does update the main content but it just doesn't update the navigation title. And way to fix this is that my settings detail view I actually never set the navigation title. So the bare minimum you have to do is to clean the navigation title. I'm basically setting it here to empty or you set it to a new value. This is so far a small bug. Try again. I go to one of my song details and then I go to the settings view and now my old title is updated to the empty one. This deep linking works quite fine. You can go wherever you want. The nice thing also about this navigation state manager here is you can add functionality to keep track of all the document all the instances that the user looked at all the songs and movies. 
>

Podstawowa akcja. Okej, znajduje się po prawej stronie i teraz mogę powiedzieć, że jeśli kliknę ten ikonę zębatą, chcę faktycznie zmienić stan nawigacji, aby przejść do widoku ustawień. Okej, może stwórzmy dla tego osobną funkcję. Więc co chcemy zrobić? Funkcja "go to settings". Więc moja ścieżka wyboru musi się zmienić i nie chcę jej dodawać na wierzch. Mogę, jeśli chcę dodać ją na wierzch, po prostu dodać ten nowy element, ale tak naprawdę chcę zastąpić całą ścieżkę. Mamy `selection state.settings`. Więc teraz tutaj mogę powiedzieć "go to settings". Okej, spróbujmy tego. Idę tutaj i naciskam moją ikonę zębatą. I jesteśmy w widoku ustawień. Niestety, zauważysz, okej, może tego nie widzisz, ale nadal pozostaje coś, czego nie lubię, a mianowicie ten tytuł z poprzedniego widoku. Spróbuj ponownie. Jeśli zaznaczysz widok tytułu, masz nawigacyjny tytuł widoku piosenki i teraz naciskam widok ustawień. Aktualizuje główną zawartość, ale po prostu nie aktualizuje tytułu nawigacji. Sposób na rozwiązanie tego problemu to ustawienie tytułu nawigacji w moim widoku szczegółów ustawień. W rzeczywistości nigdy nie ustawiałem tytułu nawigacji w moim widoku szczegółów ustawień. Więc co najmniej, co musisz zrobić, to wyczyścić tytuł nawigacji. W zasadzie ustawiam go tutaj na pusty lub możesz ustawić go na nową wartość. To jak dotąd mały błąd. Spróbujmy ponownie. Idę do jednego z moich szczegółów piosenek, a potem przechodzę do widoku ustawień i teraz mój stary tytuł jest aktualizowany na pusty. To głębokie łączenie działa całkiem dobrze. Możesz przejść gdzie chcesz. Fajna rzecz w tym menedżerze stanu nawigacji polega także na tym, że możesz dodać funkcjonalność do śledzenia wszystkich dokumentów, wszystkich instancji, które użytkownik przeglądał, wszystkich piosenek i filmów.

> So you could create a history timeline of what did you look on before. I just keep track of them collecting them. Or you can do it and go back to the previous ones for example. Do some undo redo with going back and forth in your navigation stack. I prefer to have this enum for all the selections. It makes it a little bit more easy to go around and also deal with situations where you don't actually have a value because then you need to kind of otherwise you need to kind of make up for one. And I don't like that. Lastly I want to talk about state restoration because now every time I launch I will go back to the old state and I want to make the let the user be able to resume at the same state at the same selection in the path. And what we can do is use a default and more specifically seen the scene face because the scene face stores it in the user default and makes it easy to store properties in there. If you have a navigation path. Where did I have a navigation path? Here. I had a navigation path I would have liked. I mean I really would have liked to simply say scene storage path. That would have been would have been very convenient. But this is not working because scene storage doesn't use doesn't allow you to use this type. Scene storage only supports certain types and the values that you can use is bool integer double string URL and data. It basically needs to be raw representable. So we cannot directly save the navigation path like this. We need to first transform it to a data and then save it in the scene storage. I'm not going to do this here I'm just going to do this for a custom type. 
>

Tak więc możesz stworzyć historię oglądania, która pokaże, co użytkownik oglądał wcześniej. Możesz śledzić to, zbierając te informacje. Możesz też użyć ich do powrotu do poprzednich elementów, na przykład do przeprowadzania operacji cofania i ponawiania, przechodząc tam i z powrotem po swoim stosie nawigacyjnym. Ja preferuję używanie tego enuma dla wszystkich wyborów. Ułatwia to poruszanie się i radzenie sobie z sytuacjami, w których faktycznie nie masz wartości, ponieważ w przeciwnym razie musiałbyś jakoś sobie z tym radzić. I tego nie lubię. Na koniec chciałbym poruszyć kwestię przywracania stanu, ponieważ teraz za każdym razem, gdy uruchamiam aplikację, wracam do poprzedniego stanu i chcę umożliwić użytkownikowi wznowienie dokładnie tego samego stanu i tej samej selekcji na ścieżce. Co możemy zrobić, to użyć domyślnego stanu, a dokładniej widzenia sceny, ponieważ widzenie sceny przechowuje to w UserDefaults i ułatwia przechowywanie właściwości w tym miejscu. Jeśli masz nawigacyjną ścieżkę, gdzie miałem nawigacyjną ścieżkę... tutaj. Miałem nawigacyjną ścieżkę, którą chciałbym po prostu zapisać jako `sceneStoragePath`. To byłoby bardzo wygodne. Ale to nie działa, ponieważ `sceneStorage` nie pozwala na użycie tego typu. `sceneStorage` obsługuje tylko określone typy, a wartości, które można w nim przechowywać, to: `bool`, `integer`, `double`, `string`, `URL` i `data`. W zasadzie musi być on reprezentowalny jako surowa wartość. Dlatego nie możemy bezpośrednio zapisać nawigacyjnej ścieżki w ten sposób. Musimy najpierw przekształcić ją w `data`, a następnie zapisać w `sceneStorage`. Nie będę tego robić tutaj, zrobię to tylko dla niestandardowego typu.

> So we can use a scene storage giving it a user default name navigation state or navigation state data. This is a data type optional because we might not have anything. Right now my state is in the navigation state manager. So I would want to save this path as a data to use the default. In order to do this I need to decode and encode this to data. So I'm conforming here to codable. It's going to complain because all of the subtypes need to also be codable. So I need to make my movie song and book also codable. I can just simply add here conformance to this three types and then I go back to my selection state enum which is now codable. So how do I create this data thingy from the selection path. I'm just going to use the easy back and forth conversion trick from the WWDC from the Apple project. So we're using a property with a getter and a setter and in the getter and setter we can transform data back and forth. So this is my data representation. This is a data optional. So I said we need a get and a set. So in the getter we need to create a data from our selection path. So I have to have a JSON encoder to encode my selection path and this might actually fail. This might throw an error so I'm just omitting the errors. Try. And when I set this I get the data that I need to then decode. 
>

Tak, możemy użyć `sceneStorage`, przekazując mu nazwę UserDefaults, na przykład `navigationState` lub `navigationStateData`. Jest to typ danych opcjonalnych, ponieważ może się zdarzyć, że nie mamy żadnych danych. Obecnie mój stan jest przechowywany w `navigationStateManager`, więc chcę zapisać tę ścieżkę jako dane, aby użyć domyślnego mechanizmu. Aby to zrobić, muszę zakodować i odkodować te dane. Dlatego tu dodaję zgodność z protokołem `Codable`. Po dodaniu tego protokołu będę musiał zaimplementować go również dla moich typów `Movie`, `Song` i `Book`. Mogę po prostu dodać zgodność z `Codable` dla tych trzech typów. Następnie wracam do mojego enuma `SelectionState`, który teraz jest `Codable`.

Jak stworzyć ten obiekt danych z mojej ścieżki wyboru? Skorzystam z łatwego triku konwersji w przód i wstecz z WWDC od Apple. Używamy własności z getterem i setterem, a w getterze i setterze możemy przekształcać dane tam i z powrotem. Oto moja reprezentacja danych. Jest to typ danych opcjonalnych. Musimy zaimplementować getter i setter. W getterze musimy utworzyć dane z naszej ścieżki wyboru. Muszę użyć `JSONEncoder`, aby zakodować moją ścieżkę wyboru, i to może się nie powieść, więc pomijam obsługę błędów (`try`). Kiedy to ustawiam, mam dane, które muszę potem zdekodować.

> So JSON decoder decode and the type that I need to decode is this array of selection state from the new value which is optional. So I only should do this if I have something. So this is guard let data equal new value else return. Now I can use this to decode and I try. This is a path because I said here try. I might not actually have something and I forgot to say here this is what type. I actually want to now set this to my selection path but only if I have something. So I'm also adding it here to my guard statement. So I cannot do anything with this and I'm not. Otherwise I set my selection path to the decoded one. I'm doing it a little bit different from the WWDC example from the official example from the Apple example because they are actually decode saved the whole navigation state manager properties. Maybe you have multiple in here and I'm also saving all of the data. So I'm saving the movie songs and books that are on the stack and I set them all in case during your this data gets there. So some updates have been done to the songs that are in this array. Next time I'm loading I want to actually use the newer updated versions. So one way of doing this is not saving everything or you can instead of setting here the selected path before a fetch updated new model data for each ID. 
>

Więc dekoder JSON dekoduje, a typem, który muszę zdekodować, jest ta tablica stanów wyboru pochodzących z nowej wartości, która jest opcjonalna. Czyli powinienem to zrobić tylko wtedy, gdy mam coś do zdekodowania. Dlatego stosuję konstrukcję guard let, gdzie sprawdzam, czy dane są równe nowej wartości, a jeśli nie są, po prostu wychodzę. Teraz mogę użyć tego do dekodowania i próbuję tego użyć. To jest konieczne, ponieważ używam tutaj słowa kluczowego 'try'. Mogę wcale nie mieć danych, a zapomniałem też podać, jakiego typu są te dane. Teraz chcę ustawić moją ścieżkę wyboru, ale tylko jeśli mam coś do zdekodowania. Dlatego dodaję to także do mojej klauzuli guard. W przeciwnym razie ustawiam moją ścieżkę wyboru na zdekodowany obiekt. Robię to trochę inaczej niż przykład z WWDC, oficjalny przykład od Apple, ponieważ oni zwykle dekodują i zapisują cały stan nawigacji w menedżerze właściwości. Możliwe, że mają ich tam wiele, ale ja zapisuję wszystkie dane. Zapisuję filmy, piosenki i książki, które są na stosie, i ustawiam je wszystkie, jeśli przychodzą nowe dane. Jeśli zostały dokonane jakieś aktualizacje w piosenkach znajdujących się w tej tablicy, chcę używać nowszych, zaktualizowanych wersji przy następnym ładowaniu. Jednym ze sposobów na osiągnięcie tego celu jest niezapisywanie wszystkiego, co masz, lub możesz, zamiast tego, po prostu ustawić ścieżkę wyboru przed pobraniem zaktualizowanych danych modelu dla każdego identyfikatora

> So you can use the ID because that should not have changed to fetch the new ones and then set the path from there. This setter should actually only be called once during launch. So this is when we use when we launch we want to set our selection state once but we need to decode this. We need to create the data multiple times because every time our selection path changes we want to save it to as a data in user defaults with scene storage. So I need to know when the selection path changes. So there's one way they did it in the sample project is using a combination of combine and async await and this is a little bit more difficult and yeah it really depends if you want to use it. It does work. So we have because we want to know when the whole for me I have an alternative but if you want to if you save the whole selection state manager we need to know when this changes. So this is in the object will change publisher and we need to create a async publisher for this. Yeah object will change sequence the types is a yeah the types are interesting but this is normal. So what we want to have is an async publisher. Okay so for what I want to use is the observed the object will change publisher because it's the one that where my view model changes. So every time this is triggered I know something changed and then I can save my data again. So this is in the object will change and in order to transform this to something async. So you see this is the this is a newer feature which is async publisher although it's probably already there for two versions. So values I was going to complain because types on match. 
>

Tak więc możesz użyć identyfikatora (ID), ponieważ ten identyfikator nie powinien ulec zmianie, aby pobrać nowe dane, a następnie ustawić ścieżkę na podstawie tych danych. Ta metoda ustawiania powinna być wywoływana tylko raz podczas uruchamiania. Kiedy uruchamiamy aplikację, chcemy ustawić nasz stan wyboru tylko raz, ale musimy to zdekodować wielokrotnie. Za każdym razem, gdy zmienia się nasza ścieżka wyboru, chcemy zapisać ją jako dane w UserDefaults z użyciem Scene Storage. Potrzebuję wiedzieć, kiedy zmienia się nasza ścieżka wyboru. W projekcie przykładowym zastosowano pewien sposób na połączenie combine oraz async/await, co jest nieco bardziej zaawansowane i zależy od preferencji użytkownika. To działa. Potrzebujemy tego, ponieważ chcemy wiedzieć, kiedy cały stan naszego menedżera wyboru ulega zmianie. To jest w wydawcy objectWillChange, który musi być przekształcony w async publisher. Chcemy używać właśnie tego obiektu, ponieważ zmienia się wraz ze zmianami w naszym modelu widoku. Za każdym razem, gdy jest aktywowany, wiemy, że coś się zmieniło, i możemy ponownie zapisać nasze dane. W celu przekształcenia go w coś async, korzystamy z objectWillChange i musimy stworzyć async publisher. To jest nowa funkcja, ale prawdopodobnie już jest dostępna od dwóch wersji. Początkowo miałem pewne problemy z dopasowaniem typów, ale teraz jest już dobrze.

> Yes because this is so this is returning an async publisher and self is the one that was before. Just trying to figure out how just so this is a object maybe I just should have published a copy or everything object will change publisher and it doesn't notice because I need to import combine combine should have known that this is the most important thing. Always forget to import combine. Okay this is now a sequence of all of the previous values but usually when you attach this you only want to have the recent one. So they used buffer of one so they just want to have the last one keep by request and a full job oldest. And now the types don't match again. So this is now I'm just going to copy the type from the error. Okay now we have this object will change sequence and can use the task modifier that was the whole point because the task modifier is connected to the lifecycle of this view. So whenever we have this root view or this tab view it will perform this as long as it's there. So even every time I push this is alive. And the first thing I want to do is I have here my data. The first time I'm launching I want to take my data and set this to my navigation state. So I need to take it from here from the scene storage and place it in my state manager. So this is my navigation state managers data property and I'm setting the safe navigation state data there. You can also if this is no like the first time this is not a problem because then it wants you to set up. This is when I said this and if I if it's not and it doesn't continue and I'm not going to set my selection path here. It is the first time this is free set during launch. 
>

Tak, ponieważ to zwraca async publisher, a self to jest ten, który był wcześniej. Próbuję właśnie zrozumieć, tak więc to jest obiekt, może powinienem opublikować kopię albo wszystko, objectWillChange publisher, ale to nie działa, bo muszę zaimportować Combine. Zawsze zapominam, żeby zaimportować Combine. Okej, teraz to jest sekwencja wszystkich poprzednich wartości, ale zazwyczaj, kiedy dołączasz to, chcesz mieć tylko tę ostatnią. Użyli więc bufora o rozmiarze jeden, bo chcą mieć tylko ostatnią wartość. I teraz znowu typy nie pasują. No więc teraz po prostu skopiuję typ z błędu. Okej, teraz mamy tę sekwencję objectWillChange i możemy użyć modyfikatora task, a to było właśnie główne założenie, bo modyfikator task jest połączony z cyklem życia tego widoku. Więc za każdym razem, gdy mamy ten widok główny lub ten widok karty, zostanie on wykonany, dopóki będzie istnieć. Nawet za każdym razem, gdy wciskam, to jest nadal aktywne. I pierwsza rzecz, jaką chcę zrobić, to mam tutaj swoje dane. Pierwszy raz, gdy uruchamiam, chcę wziąć moje dane i ustawić je jako stan nawigacji. Więc muszę wziąć je stąd, ze Scene Storage, i umieścić w moim menedżerze stanu. To jest właśnie właściwość danych mojego menedżera stanu nawigacji i ustawiam tam bezpieczne dane stanu nawigacji. Jeśli to jest pierwszy raz, to nie ma problemu, bo wtedy chce, żebym to skonfigurował. To jest to, o czym mówiłem wcześniej. Jeśli to nie jest pierwszy raz, to po prostu nie kontynuuję i nie ustawiam mojej ścieżki wyboru tutaj. To jest ustawiane tylko podczas pierwszego uruchomienia.

> And now every time I and the other way around because I never actually set this data here I need to get the updates for my navigation state manager the navigation state managers and now I can use this object will change sequence. This is a sequence I not really I don't know much about async await so please don't expect a good explanation from me now. But it's the because it's a wait we need to use here. Await keyword this is a sequence we don't really care about what values are there we just want to execute and say our navigation state data is now coming from the state managers data. So this is safe state to use our defaults. My app doesn't really do everything correctly because I have a yeah here I have this tab view with everything in. So let's just test this by itself. If I only have this for tab view in my app so instead of the content view I use here my third tab view so we can test this and learn we need to launch a couple of times to see. Okay so this is the root view I need to go somewhere in one of my stacks. Okay so I navigated two levels deep now I close this is for the user defaults to work properly otherwise it needs a little bit it doesn't always save them when I launch again I'm in the same state which is this two levels deep. You can also test this by going to a different one settings and then launch again and now we go back to settings. So this is working fine with this task modifier. 
>

I teraz za każdym razem, kiedy i odwrotnie, ponieważ nigdy faktycznie nie ustawiałem tych danych tutaj, potrzebuję aktualizacji dla mojego menedżera stanu nawigacji. Teraz mogę użyć tej sekwencji objectWillChange. To jest sekwencja, którą nie bardzo znam, bo nie znam się za dobrze na async/await, więc proszę, nie oczekuj ode mnie teraz dobrej wyjaśnienia. Ale to dlatego, że jest to async/await, musimy użyć słowa kluczowego await tutaj. To jest sekwencja, nie obchodzi nas, jakie są tam wartości, chcemy po prostu wykonać akcję i powiedzieć, że nasze dane stanu nawigacji pochodzą teraz z danych menedżera stanu. Więc to jest bezpieczne, aby używać UserDefaults. Moja aplikacja nie robi wszystkiego dobrze, bo mam tu ten widok karty ze wszystkim w środku. Tak więc przetestujmy to samodzielnie. Jeśli mam to tylko dla widoku karty w mojej aplikacji, zamiast ContentView używam mojego trzeciego widoku karty, więc możemy to przetestować i zobaczyć, czy działa. Musimy uruchomić kilka razy, żeby zobaczyć. Okej, to jest widok główny, muszę gdzieś przejść w jednym z moich stosów. Okej, teraz jestem na dwa poziomy głęboko, teraz to zamykam. To jest dla UserDefaults, żeby działały poprawnie, bo czasami nie zawsze zapisują, gdy ponownie uruchamiam. Ponownie jestem w tym samym stanie, który ma dwa poziomy głęboko. Można to także przetestować, przechodząc do innego ustawienia, a potem ponownie uruchamiając i teraz wracamy do ustawień. Więc to działa dobrze z tym modyfikatorem task.

> Alternatively if you don't want to use the task you can use because I mean in my case I have the possibility because I only store one property anyway. So in case of on receive of my navigation state manager selected path. Okay I need to have this is with a publisher so the dollar sign needs to be in front of the selection path. So this is now the updated path. I actually don't really need this because I had this convenience function so in my navigation state managers data I can store this to my navigation data. So this is the save state to user defaults thing. So this is the saving and then we store during launch we can use on appear. So doing on appear I want to use the navigation state the navigation data and reset this to my navigation managers data. So this is the restore during launch. I do not the one problem with this is I don't really want to save the very first element because this is the empty one. So I can use here drop first and we can try. Okay so we are going back to the original settings and now I can navigate to one of the deeper levels I leave. We trying the same and we go back to this level. I also want to make sure that I am going correctly to the root view if I'm there.
>

Alternatywnie, jeśli nie chcesz używać modyfikatora task, możesz zastosować inne podejście, zwłaszcza jeśli przechowujesz tylko jedną właściwość. W moim przypadku mam tę możliwość, ponieważ przechowuję tylko jedną właściwość. W przypadku otrzymania informacji od mojego menedżera stanu nawigacji dotyczącej ścieżki wyboru, muszę mieć to związane z wydawcą, więc znak dolara musi być przed właściwością selectionPath. To jest zaktualizowana ścieżka. Właściwie nie potrzebuję tego, ponieważ mam tę funkcję ułatwiającą, która pozwala mi zapisać moje dane nawigacyjne w menedżerze stanu nawigacji. To jest funkcja saveStateToUserDefaults. Jest to zapis, a podczas uruchamiania możemy użyć modyfikatora onAppear. W momencie pojawienia się widoku chcę użyć danych nawigacyjnych i przywrócić je do mojego menedżera stanu nawigacji. To jest przywracanie stanu podczas uruchamiania. Jedynym problemem jest to, że nie chcę zapisywać bardzo pierwszego elementu, ponieważ jest on pusty. Mogę użyć funkcji dropFirst do pominięcia pierwszego elementu i spróbować tego. Okej, więc wracamy do pierwotnych ustawień, teraz mogę przejść do jednego z głębszych poziomów i wrócić. Próbujemy tego samego i wracamy do tego poziomu. Chcę się także upewnić, że wracam poprawnie do widoku głównego, jeśli jestem tam.

>  So I leave now and I'm indeed on the root view. So you can do it is this two ways as you see the fancy async away combined way or here with the only combine where I used to separate things one time the on receive to get the updates from the selection path. This works because I really only have one property that I actually care about. If you have multiple things you need to use I mean you can still use the dollar object will change the object will change publisher because I'm actually not using this thing. So this is also working. Okay so you have and you can use this one if you have multiple properties that you need to save or in my case I really have only one but I guess maybe should leave it this way because the most cleanest and future proof way. So this is it for navigation stack. We looked at navigation links how to create a programmatic navigation navigation path navigation destination and how to do state restoration. If you want to see more for example about navigation split view I'm going to link that video here. So go watch that if you are interested because navigation split view covers it all. It's obviously more interesting if you want to go for iPad or Mac. So I go watch that if you're interested give this video a like and subscribe until next time. Happy coding. you you you

Tak więc teraz wychodzę i rzeczywiście jestem na widoku głównym. Widzisz, możesz zrobić to na dwa sposoby: za pomocą zaawansowanej metody async/await lub tutaj tylko z użyciem Combine, gdzie użyłem dwóch oddzielnych części: raz onReceive do uzyskania aktualizacji ze ścieżki wyboru. To działa, ponieważ naprawdę interesuje mnie tylko jedna właściwość. Jeśli masz wiele rzeczy, o które chcesz dbać, nadal możesz użyć objectWillChange lub objectWillChange publisher, chociaż nie używam tego w rzeczywistości. Więc to też działa. Okej, więc masz dwie opcje, i możesz używać tej pierwszej, jeśli masz wiele właściwości, które chcesz zapisać, lub w moim przypadku mam naprawdę tylko jedną, ale może warto zostawić to w ten sposób, bo to najczystszy i przyszłościowo najbardziej niezawodny sposób. 

To tyle na temat nawigacji stosu. Omówiliśmy nawigację za pomocą linków, jak tworzyć nawigację programową, ścieżki nawigacji i miejsce nawigacji. Jeśli chcesz zobaczyć więcej, na przykład na temat nawigacji w podziale widoku (split view), zamieszczę link do tego wideo tutaj. Tak więc obejrzyj to, jeśli jesteś zainteresowany, ponieważ nawigacja w podziale widoku obejmuje wszystko. Jest to oczywiście bardziej interesujące, jeśli chcesz tworzyć aplikacje na iPadzie lub Macu. Tak więc obejrzyj to, jeśli jesteś zainteresowany, polub to wideo i zasubskrybuj kanał do następnego razu. Szczęśliwego kodowania!