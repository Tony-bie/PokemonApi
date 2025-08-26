# PokemonApi
## What the app does
This is a Pokédex of the first generation, featuring a list of the first 151 Pokémon with their picture, name, and ID. When you tap on a row, the app navigates you to a detailed view where you can see:

- High-quality Pokémon artwork
- Name and Pokédex number
- Type(s) with color-coded badges
- Physical information (height and weight)
- Base stats including:
  - HP
  - Attack
  - Defense
  - Special Attack
  - Special Defense
  - Speed
- Abilities (including hidden abilities)
## Which API it connects to
The app connects to the PokéAPI:

1. Initial request: https://pokeapi.co/api/v2/pokemon?limit=151
Fetches the list of first generation Pokémon names and URLs
2. Detail requests: https://pokeapi.co/api/v2/pokemon/{name}
Example: https://pokeapi.co/api/v2/pokemon/charizard
Fetches detailed information for each Pokémon when accessed

## How to run the app
Requirements
Xcode 14.0 or later
iOS 15.0 or later
Internet connection for API calls
### Steps
1. Clone this repository
2. Open Pokemon.xcodeproj in Xcode
3. Select your target device or simulator
4. Press Cmd + R or click the "Run" button
5. The app will launch with ContentView as the main interface

