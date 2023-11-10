

NavigationStack - krew pot lzy i cierpienie

https://www.youtube.com/watch?v=piAiy5vlC9k&t=3203s

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

![](2023-11-08_19-19-21%20(1)-9537778.gif)

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

Pierwszą rzeczą, którą muszę zrobić, aby pracować z niestandardowym typem, jest oczywiście utworzenie niestandardowego typu. Używam innego folderu na to, ponieważ chcę później dodać więcej plików z przykładami. To nie będzie bardzo skomplikowany model. Powiedzmy, że mam typ książki. Jest to plik Swift o nazwie `book`. Jest to typ danych, więc musi to być struktura `Book`.

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

 Nawigacyjne łącze faktycznie daje ci właściwe informacje. Tutaj Xcode mówi, że wymaga, aby `Book` zgodny był z `Hashable`. *Wróć do `Book` i dodaj protokół  `Hashable`. Nic wiecej nie musimy zmieniac, bo jest automatycznie zgodny z `Hashable`, dzieki temu, że  wartości wewnątrz są zgodne z `Hashable`.* Teraz wróć do mojego widoku drugiej karty i błędy znikają. Teraz mam moją listę bez linków, ponieważ jeszcze nie zdefiniowałem `navigationDestination`. Więc stwórzmy nowy widok z `BookDetailView`. To po prostu przyjmuje książkę i dodaję przykład w podglądzie. 

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

To jest `VStack` dla każdej z moich wybranych ścieżek książki. Teraz pokazuje mi książkę, a ja pokazuję tutaj tytuł książki. Okej, teraz kiedy tutaj kliknę, widzisz, że mam wybraną. Zaleta polega teraz na tym, że widzisz wszystkie wartości, które są w twoim stosie nawigacyjnym. 

Jeśli na przykład chcesz wrócić do określonej wartości, masz teraz tę możliwość. Na przykład mogę zresetować całą ścieżkę do pierwszej. Wystarczy, że uzyskam pierwszą wartość, w przeciwnym razie zwróć, a teraz mogę ustawić tę książkę. I potem przejdź do ulubionych i wróci na pierwszą kartę. 

```swift
        VStack {
            ForEach(path) {
                book in
                Text(book.title)
            }
            Button("Go to favorities", systemImage: "star.fill") {
                guard let book = books.first else { return }
                path = [book]
            }
        }
```

Możesz także, ponieważ masz całą tablicę książek, możesz przeszukać tę tablicę i usunąć wszystkie, które są za nią na górze, aż dojdziesz do tej pozycji. Ale jak widziałeś, to już robi doskonale. Głównym punktem było naprawdę to, że widzisz, że ta ścieżka lub ta ścieżka nawigacyjna to nic specjalnego. Możesz używać jej zarówno z wygaszaniem typu `navigation path`, jak i z własnym typem niestandardowym, co prawdopodobnie jest łatwiejsze, ponieważ wtedy naprawdę wiesz, co robisz.

![2023-11-09_14-43-59 (1)](2023-11-09_14-43-59%20(1).gif)

### Wiele list 

Teraz chcę przejść do bardziej złożonego przykładu, ponieważ liczby i ciągi znaków były prawdopodobnie mniej interesujące. Powiedzmy, że mam tutaj trzy różne sekcje: książki, filmy i piosenki, i chcę umieszczać na wierzchu różne rodzaje rzeczy. Więc mam trzy różne szczegóły i mogę je po prostu nakładać jeden na drugi. Zróbmy to na trzeciej karcie. To jest nowy plik, widok SwiftUI: `ThirdTabView`. Jak już powiedziałem, chcę mieć trzy różne typy, więc szybko tworzę jeszcze dwa typy dla piosenki i filmy. Ponownie mój film ma tylko jedną właściwość, która jest tytułem. Musi być identyfikowalny i zgodny z `Hashable`, ponieważ chcemy go użyć z `navigation path`. A potem mam 4 przykłady.

```swift
struct Movie: Identifiable, Hashable {
    var title: String
    let id: UUID

    init(title: String) {
        self.title = title
        self.id = UUID()
    }

    static func examples() -> [Movie] {
        [
            Movie(title: "Modern Times"),
            Movie(title: "General"),
            Movie(title: "Imperium strike back"),
            Movie(title: "Star wars")

        ]
    }
}
```



 Dla mojej piosenki mam więcej wartości. Nie musimy ich naprawdę używać. Więc mamy tytuł, artystę i rok. Znowu musi być identyfikowalny i zgodny z `Hashable`. A potem dla wygody mam tutaj te dane przykładowe.

```swift
struct  Song : Identifiable,Hashable {
    var title: String
    var artist: String
    var year:Int
    let id: UUID

    init(title: String, artist: String, year: Int) {
        self.title = title
        self.artist = artist
        self.year = year
        self.id = UUID()
    }

    static func examples() -> [Song] {
        [
            Song(title: "La Isla Bonita", artist: "Madonna", year: 1986),
            Song(title: "Billie Jean", artist: "Michael Jackson", year: 1982),
            Song(title: "Bohemian Rhapsody", artist: "Queen", year: 1975),
            Song(title: "Like a Rolling Stone", artist: "Bob Dylan", year: 1965),
            Song(title: "Imagine", artist: "John Lennon", year: 1971),
            Song(title: "Purple Haze", artist: "Jimi Hendrix", year: 1967),
            Song(title: "Smells Like Teen Spirit", artist: "Nirvana", year: 1991),
            Song(title: "Hey Jude", artist: "The Beatles", year: 1968),
            Song(title: "I Want to Hold Your Hand", artist: "The Beatles", year: 1963),
            Song(title: "Hotel California", artist: "Eagles", year: 1977)
        ]
    }
}
```

Teraz w moim widoku, ponieważ chcę tu pokazać listę wszystkich tych danych i chcę tworzyć głębsze połączenia, po prostu utworzę jeden obiekt obserwowalny, który wczytuje wszystkie te dane. Więc to jest plik SwiftUI. Jest to klasa obiektu obserwowalnego. To jest `ModelDataManager`. Mogłoby to być jakieś pobranie, z którego uzyskałbyś dane z internetu lub coś podobnego, albo pobranie ich z systemu plików. Tak więc to jest klasa `ModelDataManager`, zgodna z `ObservableObject`. I muszę mieć te trzy tablice typów danych jako `@Published var books`. Na razie to są moje przykłady. I to samo dla piosenek i filmów. Teraz, kiedy jestem w moim widoku karty trzeciej, potrzebuję tych danych. Więc tworzę instancję mojego widoku modelu jako `@StateObject` naszego `ModelDataManager` i tworzę jedną z tych instancji. Teraz mam wszystkie dane i chcemy użyć nawigacyjnego widoku stosu z `path` i `route`. Więc może po prostu pominiemy `path`, abyśmy mogli to omówić za chwilę. Tak więc tutaj muszę stworzyć mój widok `RootView` z listą wszystkich tych encji. 

```swift
struct RootView: View {
    @StateObject var model = ModelDataManager()
    var body: some View {
        List {
            Section("Books") {
                ForEach(model.books) {book in
                    NavigationLink(book.title, value: book)
                }
            }
            Section("Songs") {
                ForEach(model.songs) {song in
                    NavigationLink(song.title, value: song)
                }
            }
            Section("Movies") {
                ForEach(model.movies) {movie in
                    NavigationLink(movie.title, value: movie)
                }
            }
        }
    }
}
```

Więc powiedzmy, że to jest mój widok `route`, i musi mieć wszystkie dane. Musi mieć obserwowalny obiekt `var modelData` typu `ModelDataManager`. I to samo dotyczy inicjalizatora. Możemy to zrobić dla wygody. Po prostu tworzę tutaj listę z trzema sekcjami. Więc jest to sekcja tytułowa "songs" dla każdej z piosenek w moim `modelData`. I chcę pokazać nawigacyjne łącze z wartością, więc pokazuję tytuły tych piosenek i wartość to piosenka. Potem jeszcze jedna sekcja dla filmów. Dla każdego z tych filmów pokazuję tytuł i wartość, czyli kilka tytułów filmów, a wartość to sam film. I kolejna sekcja dla książek, gdzie pokazuję książki. Dla każdej z tych książek znów pokazuję nawigacyjne łącze, tytuł i wartość, czyli tytuł książki i wartość to sama książka. Okej, wygląda to dość dobrze, i mogę użyć tego widoku `RootView` w `ThirdTabView`. Więc to jest widok `route`, i musi mieć te dane. Być może dodam tytuł do widoku `RootView`.

```swift
        }
        .navigationTitle("Cacka")
```

Poza listą tworzę teraz nawigacyjny tytuł, który to jest widok `RootView`. Teraz mam moje trzy sekcje, ale nie mam do nich przypisanych widoków szczegółowych. Znowu muszę mieć swoje destynacje nawigacji dla wartości. Obecnie mam jedną dla książki i mogę pokazać widok szczegółowy książki. 

```swift
struct ThirdTabView: View {
    @StateObject var model = ModelDataManager()
    var body: some View {
        NavigationStack {
            RootView(model: model)
                .navigationDestination(for: Book.self) { book in
                    BookDetailView(book: book)
                }

        }
    }
}
```

Tak więc kliknięcie na jednej z tych książek przenosi mnie do `BookDetailView`. Zanim przejdę do pozostałych,  ponieważ teraz używamy nawigacyjnej ścieżki z tym wygaszaniem typu. Jak możemy stworzyć inny sposób, aby tego nie używać? I to można zrobić, tworząc supermodel, nie model, który enkapsuluje wszystkie inne modele. W tym przypadku, ponieważ mam trzy sekcje, jest to enum. Na razie umieszczam to tutaj. Tak więc to jest mój stan wyboru. Trzy przypadki: film, piosenka i książka, a każdy z tych przypadków ma właściwie powiązaną wartość. Jeśli jestem w sekcji filmów, mam rzeczywiście film, który chcę przypisać. Więc jest to `Movie`, `Song` lub `Book`. Możesz także mieć przypadek `Settings`. 

```swift
enum SelectionState:Hashable {
    case movie(Movie)
    case song(Song)
    case book(Book)
    case settings
}
```

Tak naprawdę go nie użyłem, ale może mogę go użyć. W widoku `RootView` dodaję kolejny przycisk lub właściwie to jest nawigacyjne łącze. Tak więc to są ustawienia, a wartość, ponieważ wcześniej mieliśmy ten problem z ustawieniami, które nie mają wartości. Nie mam nic, co chcę przekazać, ale ponieważ zmieniam to na swój własny niestandardowy typ, jest to typ wyboru, przekazuję tutaj wartość ustawień w przypadku `selection`. Faktycznie już mówi mi, że muszę zrobić to zgodne z `Hashable`. Dodajmy więc zgodność z `Hashable`. 

  

```swift
    NavigationLink("Settings", value: SelectionState.settings)
```



Teraz nie ma już żadnych skarg, i mam tu ładny przycisk ustawień, ponieważ chcę teraz użyć tego rodzaju nawigacji. Moje wartości też muszą się zmienić. Tak więc książki stają się stanami nawigacji `navigation states`, z tą książką enkapsulowaną, film z tym filmem enkapsulowanym, a piosenka z tą piosenką przypisaną. 

```swift
struct RootView: View {
    @StateObject var model = ModelDataManager()
    var body: some View {
        List {
            Section("Books") {
                ForEach(model.books) {book in
                    NavigationLink(book.title, value: SelectionState.book(book))
                }
            }
            Section("Songs") {
                ForEach(model.songs) {song in
                    NavigationLink(song.title, value: SelectionState.song(song))
                }
            }
            Section("Movies") {
                ForEach(model.movies) {movie in
                    NavigationLink(movie.title, value: SelectionState.movie(movie))
                }
            }
            NavigationLink("Settings", value: SelectionState.settings)
        }
        .navigationTitle("Cacka")
        .navigationBarTitleDisplayMode(.inline)
    }
}
```

Okej, teraz wracając do mojego widoku trzeciej karty, destynacje, jeśli chcę teraz używać tych, muszą zostać zmienione, ponieważ teraz to już nie działa. Więc muszę teraz używać `navigation state`. Teraz to już nie jest książka, to jest stan, a ponieważ to jest enum, mogę użyć switch case. Tak więc dla `state` mam `case.song` i przypisuję to do `let song`, dla `case.movie` mam `let movie`, dla `case.book` mam `let book`, a dla `case.settings` nie mam żadnych widoków szczegółowych. Mogę użyć jednego z tych. Muszę jednak stworzyć widoki szczegółowe dla piosenki, filmu i ustawień. Więc po prostu szybko je stworzę. Widok szczegółowy piosenki. Jeśli nie chcesz tego robić samodzielnie, możesz po prostu użyć przykładów, które stworzyłem, i użyć plików z mojego repozytorium na GitHubie. Okej, teraz mam ten widok szczegółowy piosenki. 

```swift
struct SongDetailView: View {
    let song: Song
    var body: some View {
        VStack{
            Text("Song detail")
            Text(song.title)
            Text(song.artist)
            Text("\(song.year)")
        }
    }
}

#Preview {
    SongDetailView(song: Song.examples().randomElement()!)
}
```

Film 

```swift
struct MovieDetailView: View {
    let movie: Movie
    var body: some View {
        VStack {
            Text("Movie detail view")
            Text(movie.title)
        }
    }
}

#Preview {
    MovieDetailView(movie: Movie.examples().randomElement()!)
}

```

Potem widok ustawień. 

```swift
struct SettingsView: View {
    var body: some View {
        Text("Settings view")
    }
}

#Preview {
    SettingsView()
}
```

 Mogłem użyć widoku destynacji książki dla szczegółów, ale tutaj wartość to typ książki, a chcę użyć innego. Więc po prostu stwórzmy inny widok szczegółowy książki. Właściwie prawdopodobnie powinienem zmienić nazwę istniejącego np. na `BookDestinationView`. Więc możemy zasadniczo używać wszystkiego takiego samego, z wyjątkiem tego, że wartość teraz musi być moim stanem wyboru dla książki i przypisaniem dowolnej książki, którą chcę tutaj pokazać. Okej, nadal nie buduje się, ponieważ mój widok główny, ponieważ mój widok karty trzeciej wymaga kilku poprawek. Okej, po prostu dodajmy tutaj mój widok szczegółowy piosenki dla piosenki, mój widok szczegółowy filmu, mój widok szczegółowy książki i mój widok ustawień.

```swift
struct ThirdTabView: View {
    @StateObject var model = ModelDataManager()
    var body: some View {
        NavigationStack {
            RootView(model: model)
                .navigationDestination(for: SelectionState.self) { state in
                    switch state {
                    case .song(let song):
                        SongDetailView(song: song)
                    case .movie(let movie):
                        MovieDetailView(movie: movie)
                    case .book(let book):
                        BookDetailView(book: book)
                    case .settings:
                        SettingsView()
                    }
                }
        }
    }
}
```



Tak więc jest to główny widok, który widzisz po prawej stronie, a ja mam teraz osobno definicję lub zestaw widoków szczegółowych, które chcę pokazać. Jedną z zalet tego modyfikatora nawigacji jest znacznie czystsze i zorganizowane. Być może powinienem przenieść ustawienia tutaj i umieścić je z ikoną trybiki. Możesz to wypróbować, wszystkie działają. Okej, nie dodaję więcej informacji. Dodano więcej informacji tylko dla sugestii książki. Możesz również dodać więcej linków dla na przykład piosenek, a w tym przypadku powinieneś po prostu użyć danych, które mam tutaj w moim menedżerze modeli. Więc w widoku szczegółowym dla piosenki mogę dodać podział i tekst, na przykład "Inni też polubili", i teraz chcę pokazać listę wszystkich innych piosenek. 

Te dane są w moim modelu `ModelDataManager`, ponieważ prawdopodobnie będę ich potrzebował wszędzie, dodać do środowiska  `environmentObject (modelManager)`, a teraz mogę to użyć w moim widoku szczegółowym dla piosenki. Tak więc, dostęp do niego z obiektu środowiskowego `var modelData`, jest to typ `modelManager`. Podgląd będzie się zawieszał, chyba że dodam instancję tego typu `modelManager` jako wszystkie dane. I teraz mogę użyć tutaj dla każdej z moich piosenek z `modelData songs`. Można również podlinkować różne rzeczy. Dodawanie tutaj nawigacyjnego łącza z wartością i tytułem, na przykład piosenka, jeśli chcesz mieć różne, dodaj ikonę piosenki.

```swift
struct SongDetailView: View {
    let song: Song
    @EnvironmentObject var model: ModelDataManager
    var body: some View {
        VStack{
            Text("Song detail")
            Text(song.title)
            Text(song.artist)
            Text("\(song.year)")
            Divider()
            VStack(alignment: .leading) {
                Text("Inne piosenki do polubienia")

                ForEach(model.songs) { song in
                    NavigationLink(value: song) {
                        Label(song.title,systemImage: "music.note")
                    }
                }
            }
        }
    }
  }
  #Preview {
    SongDetailView(song: Song.examples().randomElement()!)
        .environmentObject(ModelDataManager())
}
```



To jest etykieta z tytułem piosenki, a obraz systemowy to nuta. Prawdopodobnie umieść to w `VStack` z wiodącym wyrównaniem i połącz tytuł z nutą. Okej, teraz mamy trochę więcej nawigacji. Okej, mamy awarię. Takie rzeczy zwykle nie działają bardzo dobrze. Aby uruchomić to w symulatorze, muszę to ć zaqkladki do głównego okna. Nie zrobiłem tego do tej pory. Więc w moim widoku zawartości teraz dodam ten widok karty o którym cały czas mówiłem, ale nigdy go faktycznie nie utworzyłem. 

```swift
struct ContentView: View {
    var body: some View {
        TabView{
            FirstTabView()
                .tabItem {
                    Label("First", systemImage: "square.grid.3x3.middleleft.filled")
                }
            SecondViewTab()
                .tabItem {
                    Label("Second", systemImage: "book")
                }

            ThirdTabView()
                .tabItem {
                    Label("Third", systemImage: "music.quarternote.3")
                }
        }
    }
}
```

Mamy nasze zkładki na głównym oknie aplikacji. Teraz, przystąpmy do uruchomienia tego. Przejdźmy do trzeciej karty, a następnie kliknijmy na jedną z piosenek. W porządku, pojawił się krytyczny błąd. Wygląda na to, że nie można odnaleźć modelu środowiskowego `modelDataManager`. Widok szczegółowy dla piosenki, który próbuję użyć, nie ma dostępu do tego środowiska. Teraz muszę sprawdzić, gdzie dokładnie tworzę instancję mojego widoku szczegółowego dla piosenki. Zrobiłem to w moim widoku trzeciej karty tutaj, a jest to destynacja nawigacyjna `songDetailView`. Później dodałem to jako `environmentObject`, zakładając, że dostanę do tego dostęp wszędzie, ale niestety tak się nie dzieje. Stąd moja sugestia dotycząca modyfikatora nawigacji. Musisz również dodać to tutaj. Stworzymy więc grupę, ponieważ to jest niezbędne. Prawdopodobnie bardziej zalecane jest dodanie tego do wszystkich widoków zawartych w tej grupie.

```swift
struct ThirdTabView: View {
    @StateObject var model = ModelDataManager()
    var body: some View {
        NavigationStack {
            RootView(model: model)
                .navigationDestination(for: SelectionState.self) { state in
                    Group {
                        switch state {
                        case .song(let song):
                            SongDetailView(song: song)
                        case .movie(let movie):
                            MovieDetailView(movie: movie)
                        case .book(let book):
                            BookDetailView(book: book)
                        case .settings:
                            SettingsView()
                        }
                    }
                    .environmentObject(model)
                }
        }
              NavigationStack {
            RootView(model: model)
                .navigationDestination(for: SelectionState.self) { state in
                    Group {
                        switch state {
                        case .song(let song):
                            SongDetailView(song: song)
                        case .movie(let movie):
                            MovieDetailView(movie: movie)
                        case .book(let book):
                            BookDetailView(book: book)
                        case .settings:
                            SettingsView()
                        }
                    }

                }

        }
        .environmentObject(model)
    }
}
```

Jak widać, owijam moje `switch case` tutaj w grupę. A jeszcze leepiej w nadrzędne `NavigationStack` Dzięki temu ten modyfikator widoku jest dodawany do wszystkich moich widoków wewnątrz niego. Mam nadzieję, że teraz wszystko działa. Przejdźmy do mojej trzeciej karty. I tak, mamy szczegóły i widzę wszystkie piosenki. Nie działa. 

`A NavigationLink is presenting a value of type “Song” but there is no matching navigationDestination declaration visible from the location of the link. The link cannot be activated.`

`Note: Links search for destinations in any surrounding NavigationStack, then within the same column of a NavigationSplitView.`

Okej, przynajmniej teraz informacje wydają się być przydatne. Łącze prezentuje wartość typu piosenka, ale nie ma zadeklarowanej odpowiadającej mu widocznej destynacji nawigacji. I mówią ci także, jak właściwie szukają tych destynacji nawigacji. Najpierw sprawdzają otaczający stos nawigacyjny. Idą w górę drzewa widoku i jeśli tam nic nie znajdą, sprawdzają podział nawigacji. Jest to możliwe, możesz je układać jedno wewnątrz drugiego. Okej, zobaczmy, co zrobiłem w widoku szczegółowym dla piosenki. Ah tak, rzeczywiście użyłem wartości `song`, a nie mojej nowej wartości wyboru. 

```swift
                ForEach(model.songs) { song in
                  //  NavigationLink(value: song) {
                    NavigationLink(value: SelectionState.song(song)) {
                        Label(song.title,systemImage: "music.note")
                    }
                }
```

Spróbujmy jeszcze raz. Okej, teraz wszystko wydaje się działać. Okej, więc upewnij się, że dodajesz wszystkie obiekty środowiska ponownie w NavigationDestination. 

Mozemy dodac jeszcze jedna zmienna :

```swift
.environment(\.colorScheme, .dark)
```

Okej, to jest ciemny. Pozwoli nam zoabczyć jaki jest zakres zmiennych srodowiskowych ustawionych w tym miejscu. Tak, naprawdę upewnij się, gdzie umieszczasz właściwości środowiska, na najwyższym poziomie, wokół stosu nawigacji. W ten sposób wszystkie elementy je dostają.

​	Ponowne dodawanie nawigacji kontrolowanej z poziomu kodu. Musiałbym teraz przejść do NavigationStack i uzyskać dostęp do mojej właściwości `path`, ponieważ chcę to przekazać w dół do wszystkich moich widoków szczegółowych i naprawdę nie chcę przekazywać tego ręcznie. Będę używał tego samego triku z obiektem obserwowanym i następnie dodam to do środowiska, co oznacza, że muszę utworzyć inny widok modelu dla stanu nawigacji. I jest to piąty plik. Zawsze trudno nazwać to nawigacja. Menedżer stanu nawigacji. Prawdopodobnie muszę zmienić nazwy rzeczy. I jeśli chcesz, możesz również utworzyć kolejne dla swoich widoków modeli tutaj. Więc jest to klasa spełniająca protokół `ObservableObject` i właściwość, którą chcę przechowywać, jest faktycznie zdefiniowana jako stan wyboru. Więc również przenoszę to tam lub może do osobnego pliku. Więc tutaj jest to opublikowane dla `selectionPath`, a teraz jest to tablica, chociaż to jest kolekcja, a ścieżka jest kolekcją moich stanów i są one reprezentowane przez ten sam typ, którym jest mój stan wyboru. To tyle. I teraz mogę tego użyć ponownie jako `stateObject` naszego menedżera stanu nawigacji. Instancja `navigationStateManager` i mogę przekazać powiązanie w moim stosie nawigacji do `selectionPath` mojego menedżera stanu nawigacji. Tak samo chciałem to dodać tutaj do środowiska.

```swift
struct ThirdTabView: View {
    @StateObject var model = ModelDataManager()
    @StateObject var navigationStateManager = NavigationStateManager()
    var body: some View {
        NavigationStack {
          ...
        }
        .environmentObject(model)
        .environmentObject(navigationStateManager)
        .environment(\.colorScheme, .dark)
```

Dodaję obiekt środowiska dla menedżera stanu nawigacji, a teraz możemy używać tego wszędzie w jednym z naszych widoków szczegółowych. Więc tutaj w widoku szczegółowym dla piosenki mogę dodać kolejny przycisk. Okej, najpierw muszę faktycznie pobrać ten obiekt środowiska. Obiekt środowiska `var navigation` typu `navigation state manager` i nie zapomnij dodać tego do podglądu. 

```swift
import SwiftUI

struct SongDetailView: View {
    let song: Song
    @EnvironmentObject var model: ModelDataManager
    @EnvironmentObject var navigationState: NavigationStateManager
    var body: some View {
        VStack{
            Image(systemName: "music.mic.circle")
                .font(.largeTitle)
            Text("Song detail")
                .font(.title)
            Text(song.title)
            Text(song.artist)
            Text("\(song.year)")
            Divider()
            VStack(alignment: .leading) {
                Text("Inne piosenki do polubienia")
                    .font(.callout)
                
                ForEach(model.songs) { song in
                    //  NavigationLink(value: song) {
                    NavigationLink(value: SelectionState.song(song)) {
                        Label(song.title,systemImage: "music.note")
                    }
                }
            }
        }
    }
}

#Preview {
    SongDetailView(song: Song.examples().randomElement()!)
        .environmentObject(ModelDataManager())
        .environmentObject(NavigationStateManager())
}
```



```swift
struct SongDetailView: View {
    let song: Song
    @EnvironmentObject var model: ModelDataManager
    @EnvironmentObject var navigationState: NavigationStateManager
    var body: some View {
        VStack{
            Image(systemName: "music.mic.circle")
                .font(.largeTitle)
            Text("Song detail")
                .font(.title)
            Text(song.title)
            Text(song.artist)
            Text("\(song.year)")
            Divider()
            VStack(alignment: .leading) {
                Text("Inne piosenki do polubienia")
                    .font(.callout)
                
                ForEach(model.songs) { song in
                    //  NavigationLink(value: song) {
                    NavigationLink(value: SelectionState.song(song)) {
                        Label(song.title,systemImage: "music.note")
                    }
                }
            }
            Button("Go to root",systemImage: "gobackward") {
                navigationState.goToRoot()
            }
        }
        .navigationTitle("Dupa zbita")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    navigationState.goToSettings()
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SongDetailView(song: Song.examples().randomElement()!)
            .environmentObject(ModelDataManager())
            .environmentObject(NavigationStateManager())
    }
}
```

W rzeczywistości nigdy nie ustawiałem tytułu nawigacji w moim widoku szczegółów ustawień. Więc co najmniej, co musisz zrobić, to wyczyścić tytuł nawigacji. W zasadzie ustawiam go tutaj na pusty lub możesz ustawić go na nową wartość. To jak dotąd mały błąd. Spróbujmy ponownie. Idę do jednego z moich szczegółów piosenek, a potem przechodzę do widoku ustawień i teraz mój stary tytuł jest aktualizowany na pusty. To głębokie łączenie działa całkiem dobrze. Możesz przejść gdzie chcesz. Fajna rzecz w tym menedżerze stanu nawigacji polega także na tym, że możesz dodać funkcjonalność do śledzenia wszystkich dokumentów, wszystkich instancji, które użytkownik przeglądał, wszystkich piosenek i filmów.



Tak więc możesz stworzyć historię oglądania, która pokaże, co użytkownik oglądał wcześniej. Możesz śledzić to, zbierając te informacje. Możesz też użyć ich do powrotu do poprzednich elementów, na przykład do przeprowadzania operacji cofania i ponawiania, przechodząc tam i z powrotem po swoim stosie nawigacyjnym. Ja preferuję używanie tego enuma dla wszystkich wyborów. Ułatwia to poruszanie się i radzenie sobie z sytuacjami, w których faktycznie nie masz wartości, ponieważ w przeciwnym razie musiałbyś jakoś sobie z tym radzić. I tego nie lubię. Na koniec chciałbym poruszyć kwestię przywracania stanu, ponieważ teraz za każdym razem, gdy uruchamiam aplikację, wracam do poprzedniego stanu i chcę umożliwić użytkownikowi wznowienie dokładnie tego samego stanu i tej samej selekcji na ścieżce. Co możemy zrobić, to użyć domyślnego stanu, a dokładniej widzenia sceny, ponieważ widzenie sceny przechowuje to w UserDefaults i ułatwia przechowywanie właściwości w tym miejscu. Jeśli masz nawigacyjną ścieżkę, gdzie miałem nawigacyjną ścieżkę... tutaj. Miałem nawigacyjną ścieżkę, którą chciałbym po prostu zapisać jako `sceneStoragePath`. To byłoby bardzo wygodne. Ale to nie działa, ponieważ `sceneStorage` nie pozwala na użycie tego typu. `sceneStorage` obsługuje tylko określone typy, a wartości, które można w nim przechowywać, to: `bool`, `integer`, `double`, `string`, `URL` i `data`. W zasadzie musi być on reprezentowalny jako surowa wartość. Dlatego nie możemy bezpośrednio zapisać nawigacyjnej ścieżki w ten sposób. Musimy najpierw przekształcić ją w `data`, a następnie zapisać w `sceneStorage`. Nie będę tego robić tutaj, zrobię to tylko dla niestandardowego typu.



Tak, możemy użyć `sceneStorage`, przekazując mu nazwę UserDefaults, na przykład `navigationState` lub `navigationStateData`. Jest to typ danych opcjonalnych, ponieważ może się zdarzyć, że nie mamy żadnych danych. Obecnie mój stan jest przechowywany w `navigationStateManager`, więc chcę zapisać tę ścieżkę jako dane, aby użyć domyślnego mechanizmu. Aby to zrobić, muszę zakodować i odkodować te dane. Dlatego tu dodaję zgodność z protokołem `Codable`. Po dodaniu tego protokołu będę musiał zaimplementować go również dla moich typów `Movie`, `Song` i `Book`. Mogę po prostu dodać zgodność z `Codable` dla tych trzech typów. Następnie wracam do mojego enuma `SelectionState`, który teraz jest `Codable`.

Jak stworzyć ten obiekt danych z mojej ścieżki wyboru? Skorzystam z łatwego triku konwersji w przód i wstecz z WWDC od Apple. Używamy własności z getterem i setterem, a w getterze i setterze możemy przekształcać dane tam i z powrotem. Oto moja reprezentacja danych. Jest to typ danych opcjonalnych. Musimy zaimplementować getter i setter. W getterze musimy utworzyć dane z naszej ścieżki wyboru. Muszę użyć `JSONEncoder`, aby zakodować moją ścieżkę wyboru, i to może się nie powieść, więc pomijam obsługę błędów (`try`). Kiedy to ustawiam, mam dane, które muszę potem zdekodować.



Więc dekoder JSON dekoduje, a typem, który muszę zdekodować, jest ta tablica stanów wyboru pochodzących z nowej wartości, która jest opcjonalna. Czyli powinienem to zrobić tylko wtedy, gdy mam coś do zdekodowania. Dlatego stosuję konstrukcję guard let, gdzie sprawdzam, czy dane są równe nowej wartości, a jeśli nie są, po prostu wychodzę. Teraz mogę użyć tego do dekodowania i próbuję tego użyć. To jest konieczne, ponieważ używam tutaj słowa kluczowego 'try'. Mogę wcale nie mieć danych, a zapomniałem też podać, jakiego typu są te dane. Teraz chcę ustawić moją ścieżkę wyboru, ale tylko jeśli mam coś do zdekodowania. Dlatego dodaję to także do mojej klauzuli guard. W przeciwnym razie ustawiam moją ścieżkę wyboru na zdekodowany obiekt. Robię to trochę inaczej niż przykład z WWDC, oficjalny przykład od Apple, ponieważ oni zwykle dekodują i zapisują cały stan nawigacji w menedżerze właściwości. Możliwe, że mają ich tam wiele, ale ja zapisuję wszystkie dane. Zapisuję filmy, piosenki i książki, które są na stosie, i ustawiam je wszystkie, jeśli przychodzą nowe dane. Jeśli zostały dokonane jakieś aktualizacje w piosenkach znajdujących się w tej tablicy, chcę używać nowszych, zaktualizowanych wersji przy następnym ładowaniu. Jednym ze sposobów na osiągnięcie tego celu jest niezapisywanie wszystkiego, co masz, lub możesz, zamiast tego, po prostu ustawić ścieżkę wyboru przed pobraniem zaktualizowanych danych modelu dla każdego identyfikatora

 

Tak więc możesz użyć identyfikatora (ID), ponieważ ten identyfikator nie powinien ulec zmianie, aby pobrać nowe dane, a następnie ustawić ścieżkę na podstawie tych danych. Ta metoda ustawiania powinna być wywoływana tylko raz podczas uruchamiania. Kiedy uruchamiamy aplikację, chcemy ustawić nasz stan wyboru tylko raz, ale musimy to zdekodować wielokrotnie. Za każdym razem, gdy zmienia się nasza ścieżka wyboru, chcemy zapisać ją jako dane w UserDefaults z użyciem Scene Storage. Potrzebuję wiedzieć, kiedy zmienia się nasza ścieżka wyboru. W projekcie przykładowym zastosowano pewien sposób na połączenie combine oraz async/await, co jest nieco bardziej zaawansowane i zależy od preferencji użytkownika. To działa. Potrzebujemy tego, ponieważ chcemy wiedzieć, kiedy cały stan naszego menedżera wyboru ulega zmianie. To jest w wydawcy objectWillChange, który musi być przekształcony w async publisher. Chcemy używać właśnie tego obiektu, ponieważ zmienia się wraz ze zmianami w naszym modelu widoku. Za każdym razem, gdy jest aktywowany, wiemy, że coś się zmieniło, i możemy ponownie zapisać nasze dane. W celu przekształcenia go w coś async, korzystamy z objectWillChange i musimy stworzyć async publisher. To jest nowa funkcja, ale prawdopodobnie już jest dostępna od dwóch wersji. Początkowo miałem pewne problemy z dopasowaniem typów, ale teraz jest już dobrze.



Tak, ponieważ to zwraca async publisher, a self to jest ten, który był wcześniej. Próbuję właśnie zrozumieć, tak więc to jest obiekt, może powinienem opublikować kopię albo wszystko, objectWillChange publisher, ale to nie działa, bo muszę zaimportować Combine. Zawsze zapominam, żeby zaimportować Combine. Okej, teraz to jest sekwencja wszystkich poprzednich wartości, ale zazwyczaj, kiedy dołączasz to, chcesz mieć tylko tę ostatnią. Użyli więc bufora o rozmiarze jeden, bo chcą mieć tylko ostatnią wartość. I teraz znowu typy nie pasują. No więc teraz po prostu skopiuję typ z błędu. Okej, teraz mamy tę sekwencję objectWillChange i możemy użyć modyfikatora task, a to było właśnie główne założenie, bo modyfikator task jest połączony z cyklem życia tego widoku. Więc za każdym razem, gdy mamy ten widok główny lub ten widok karty, zostanie on wykonany, dopóki będzie istnieć. Nawet za każdym razem, gdy wciskam, to jest nadal aktywne. I pierwsza rzecz, jaką chcę zrobić, to mam tutaj swoje dane. Pierwszy raz, gdy uruchamiam, chcę wziąć moje dane i ustawić je jako stan nawigacji. Więc muszę wziąć je stąd, ze Scene Storage, i umieścić w moim menedżerze stanu. To jest właśnie właściwość danych mojego menedżera stanu nawigacji i ustawiam tam bezpieczne dane stanu nawigacji. Jeśli to jest pierwszy raz, to nie ma problemu, bo wtedy chce, żebym to skonfigurował. To jest to, o czym mówiłem wcześniej. Jeśli to nie jest pierwszy raz, to po prostu nie kontynuuję i nie ustawiam mojej ścieżki wyboru tutaj. To jest ustawiane tylko podczas pierwszego uruchomienia.



I teraz za każdym razem, kiedy i odwrotnie, ponieważ nigdy faktycznie nie ustawiałem tych danych tutaj, potrzebuję aktualizacji dla mojego menedżera stanu nawigacji. Teraz mogę użyć tej sekwencji objectWillChange. To jest sekwencja, którą nie bardzo znam, bo nie znam się za dobrze na async/await, więc proszę, nie oczekuj ode mnie teraz dobrej wyjaśnienia. Ale to dlatego, że jest to async/await, musimy użyć słowa kluczowego await tutaj. To jest sekwencja, nie obchodzi nas, jakie są tam wartości, chcemy po prostu wykonać akcję i powiedzieć, że nasze dane stanu nawigacji pochodzą teraz z danych menedżera stanu. Więc to jest bezpieczne, aby używać UserDefaults. Moja aplikacja nie robi wszystkiego dobrze, bo mam tu ten widok karty ze wszystkim w środku. Tak więc przetestujmy to samodzielnie. Jeśli mam to tylko dla widoku karty w mojej aplikacji, zamiast ContentView używam mojego trzeciego widoku karty, więc możemy to przetestować i zobaczyć, czy działa. Musimy uruchomić kilka razy, żeby zobaczyć. Okej, to jest widok główny, muszę gdzieś przejść w jednym z moich stosów. Okej, teraz jestem na dwa poziomy głęboko, teraz to zamykam. To jest dla UserDefaults, żeby działały poprawnie, bo czasami nie zawsze zapisują, gdy ponownie uruchamiam. Ponownie jestem w tym samym stanie, który ma dwa poziomy głęboko. Można to także przetestować, przechodząc do innego ustawienia, a potem ponownie uruchamiając i teraz wracamy do ustawień. Więc to działa dobrze z tym modyfikatorem task.



Alternatywnie, jeśli nie chcesz używać modyfikatora task, możesz zastosować inne podejście, zwłaszcza jeśli przechowujesz tylko jedną właściwość. W moim przypadku mam tę możliwość, ponieważ przechowuję tylko jedną właściwość. W przypadku otrzymania informacji od mojego menedżera stanu nawigacji dotyczącej ścieżki wyboru, muszę mieć to związane z wydawcą, więc znak dolara musi być przed właściwością selectionPath. To jest zaktualizowana ścieżka. Właściwie nie potrzebuję tego, ponieważ mam tę funkcję ułatwiającą, która pozwala mi zapisać moje dane nawigacyjne w menedżerze stanu nawigacji. To jest funkcja saveStateToUserDefaults. Jest to zapis, a podczas uruchamiania możemy użyć modyfikatora onAppear. W momencie pojawienia się widoku chcę użyć danych nawigacyjnych i przywrócić je do mojego menedżera stanu nawigacji. To jest przywracanie stanu podczas uruchamiania. Jedynym problemem jest to, że nie chcę zapisywać bardzo pierwszego elementu, ponieważ jest on pusty. Mogę użyć funkcji dropFirst do pominięcia pierwszego elementu i spróbować tego. Okej, więc wracamy do pierwotnych ustawień, teraz mogę przejść do jednego z głębszych poziomów i wrócić. Próbujemy tego samego i wracamy do tego poziomu. Chcę się także upewnić, że wracam poprawnie do widoku głównego, jeśli jestem tam.



Tak więc teraz wychodzę i rzeczywiście jestem na widoku głównym. Widzisz, możesz zrobić to na dwa sposoby: za pomocą zaawansowanej metody async/await lub tutaj tylko z użyciem Combine, gdzie użyłem dwóch oddzielnych części: raz onReceive do uzyskania aktualizacji ze ścieżki wyboru. To działa, ponieważ naprawdę interesuje mnie tylko jedna właściwość. Jeśli masz wiele rzeczy, o które chcesz dbać, nadal możesz użyć objectWillChange lub objectWillChange publisher, chociaż nie używam tego w rzeczywistości. Więc to też działa. Okej, więc masz dwie opcje, i możesz używać tej pierwszej, jeśli masz wiele właściwości, które chcesz zapisać, lub w moim przypadku mam naprawdę tylko jedną, ale może warto zostawić to w ten sposób, bo to najczystszy i przyszłościowo najbardziej niezawodny sposób. 

To tyle na temat nawigacji stosu. Omówiliśmy nawigację za pomocą linków, jak tworzyć nawigację programową, ścieżki nawigacji i miejsce nawigacji. Jeśli chcesz zobaczyć więcej, na przykład na temat nawigacji w podziale widoku (split view), zamieszczę link do tego wideo tutaj. Tak więc obejrzyj to, jeśli jesteś zainteresowany, ponieważ nawigacja w podziale widoku obejmuje wszystko. Jest to oczywiście bardziej interesujące, jeśli chcesz tworzyć aplikacje na iPadzie lub Macu. Tak więc obejrzyj to, jeśli jesteś zainteresowany, polub to wideo i zasubskrybuj kanał do następnego razu. Szczęśliwego kodowania!