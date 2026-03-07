# Tsuzuki Connect (続きコネクト) 🌸

Hey there! Welcome to **Tsuzuki Connect**, a passion project built entirely with Flutter. It's a visual novel designed to help you learn Japanese naturally—by throwing you right into the story! 

Instead of flashcards or endless grammar drills, you learn by doing. You play through daily life scenarios in Tokyo, build relationships (Kizuna) with the characters, and figure out the language along the way to progress the story.

## A Peek Inside 👀

|![Screenshot 2](https://is2-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/25/ab/74/25ab74bf-7a56-7e29-704b-5d6e7dbdd2c7/_U041d_U043e_U0432_U044b_U0438_U0306__U043f_U0440_U043e_U0435_U043a_U0442__U002810_U0029.jpg/0x0ss.png)  | ![Screenshot 3](https://is2-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/24/9e/4c/249e4c25-77e3-dd70-f12e-7709b8afe4b7/_U041d_U043e_U0432_U044b_U0438_U0306__U043f_U0440_U043e_U0435_U043a_U0442__U002811_U0029.jpg/0x0ss.png)  |
|---|---|

## What Makes It Special? ✨

* **Play to Learn**: Every choice you make in dialogue relies on your understanding of Japanese. No pressure, just immersion!
* **Your Personal `Kotoba` Log**: Whenever you encounter new words or grammar, the game automatically saves them so you can review them later by JLPT level or category.
* **Make Friends in Tokyo**: The storyline branches based on how you interact. Build deep bonds with out cast of characters!
* **Built for Everywhere**: Because it's written in Flutter, it works beautifully on iOS, Android, Desktop, and Web. Plus, once you download it, you can play entirely offline.

## Want to poke around the code? 🛠️

Awesome! We’ve kept the architecture clean and modern so it's easy to jump into:

* **State**: Unsurprisingly, we love [Riverpod](https://riverpod.dev/).
* **Local Storage**: Everything from your save state to your learned vocabulary is handled by [Drift](https://drift.simonbinder.eu/) (SQLite).
* **Routing**: [GoRouter](https://pub.dev/packages/go_router) keeps navigation snappy.
* **Content Engine**: The entire visual novel script is driven by simple, flexible JSON files.

### Getting It Running

1. Clone it down:
   ```bash
   git clone https://github.com/TaalayDev/tsuzuki_connect.git
   cd tsuzuki_connect
   ```
2. Grab the dependencies:
   ```bash
   flutter pub get
   ```
3. Generate the required files (for Drift and Riverpod):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Fire it up!
   ```bash
   flutter run
   ```

*(Note: We also have a handy `./manage.sh` script if you want to build APKs, App Bundles, or IPAs quickly!)*

## Let's Build This Together! 🤝

I'd absolutely love your help. Whether you're a Flutter wizard, a UI/UX wizard, a storyteller, or just want to fix a typo—every little bit helps! Check out `CONTRIBUTING.md` if you want to get involved.

## License
MIT License. Do whatever you'd like with the code! (See `LICENSE` for the boring legal details).

---
*Let's learn Japanese through adventure!* 🎌