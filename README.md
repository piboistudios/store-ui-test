# A Foreward

I basically made this because I'm tired of tenured .NET fanboys acting like pre-Satya Nadella Microsoft technology was worth a damn. And frankly, even still some of the stuff they put out is questionable. The most questionable thing (in my opinion) is their strange fetish for "server pages" style architecture as I like to call it... Here's (just) 3 reasons off the top of my head why server pages style tech is stupid: 

1. It's a violation of the separation of concerns, which is a fundamental software design principle. If you disagree, stop designing software.

2. Not to mention it leads to non-reproducible states __all__ of the time. How can you reproduce a state in which half of the logic is in _memory_ on the server, and in _memory_ on the web page by conventional, feasible means, without writing a billion lines of code..? 

3. You also can't really encapsulate server pages style code really well, and attempts to do so end up being riddled with just as much boilerplate as just writing the crap all over again. Argh! Damn you Microsoft!... oh right, but because you can't encapsulate them well, its extremely difficult both to use and consume server page style "UI components" (that's why adding a pre-Angular Telerik Kendo table to a UI is a massive undertaking, but adding a <b-table> to a page is [this](https://bootstrap-vue.org/docs/components/table) simple...)

I could go on, but basically server pages technology (and the tendency of Microsoft to push it out as "industry standard", this confusing their dogmatic sycophants) is trash.

Anyways enjoy.

# Haxe project

This is an example Haxe project scaffolded by Visual Studio Code.

Without further changes the structure is following:

 * `src/Main.hx`: Entry point Haxe source file
 * `build.hxml`: Haxe command line file used to build the project
 * `README.md`: This file


 ## About

 This was originally done for a coding challenge in about 3 hours. Didn't complete the front-end, so I figure, why not.

 The reason I didn't complete it was because I wrote this app twice actually :)
 First I wrote it using "server pages" style architecture (which is basically like the front-end and back-end having to share a single bunk together, even though there's an empty one)

 Then I wrote it as a Vue.js + Vuetify SPA. The Vuetify code is only long because I did that fancy full-screen dialog, but otherwise, it is far more minimal than the server pages code, and far more responsive, and functional, and uses less data, and... (we all know there's endless pros to SPAs over server pages... why go on)

 What this comes with (for no reason):
 - A mock data access layer (backed by a JSON file)
 - A micro REST API controller
 - A bloated server pages API controller
 - Some crypto stuff for ChaCha encryption/decryption (I've left all the secrets in the project intentionally..)
 - An app.config.json (some crap I just made up, because typically a scaling app has a config)

 ## Demo
 ![demo 1](https://github.com/piboistudios/store-ui-test/blob/master/dist/demo1.png?raw=true)
 ![demo 2](https://github.com/piboistudios/store-ui-test/blob/master/dist/demo2.png?raw=true)
 ![demo 3](https://github.com/piboistudios/store-ui-test/blob/master/dist/demo3.PNG?raw=true)
 ![demo 4](https://github.com/piboistudios/store-ui-test/blob/master/dist/demo4.png?raw=true)
 ![demo 5](https://github.com/piboistudios/store-ui-test/blob/master/dist/demo5.png?raw=true)

### Conclusion
The server pages equivalent is much longer, and more tedious, with less functionality.
On the other hand the SPA has more mark up because I added way more mark up (a full screen dialog... that works on mobile devices).

I also made the SPA in 30 minutes. The server pages took about 2 hours.

4x the time and effort for a crappier, slower website... but .NET fanboys luv dis stuffg

Server pages (ASP, vanilla PHP, JSP, rat's pee) all suck, please stop using them. And please stop believing everything Microsoft says about technology... they're wrong all the time. As an example, the SmtpClient, which Microsoft used to endorse like crazy about 10 years ago (and is riddled with problems... because it was poorly designed, which is why they stopped maintaining it):
 ![why Microsoft is total trash](https://github.com/piboistudios/store-ui-test/blob/master/dist/why-microsoft-is-garbage.png?raw=true)


You know what the equivalent of the above image is? Imagine going to a restaurant and they have, on the menu, an item. And next to the item, an asterisk. And in the footnotes next to the asterisk it says "Hey, seriously, don't order this, it tastes like cardboard"