# Patrician III Auto Route Editor
Auto route editor for Patrician III. This tool allows to open, edit, create and save auto route `.rou` files.

## Installation
Editor runs as a standalone program and does not require installation nor additional dependencies.

## Usage
Editor allows to open an auto route folder, create, edit and delete routes for Patrician III. Editor also supports custom pricing policies, sorting of goods and application of presets for routes.

## Structure of Auto Route files
Auto route `.rou` files encode a sequence of trade stops and, for each of those, goods which will be traded. Patrician III saves `.rou` files in a compressed format, but can read both compressed and uncompressed files. Credit goes to [Benedikt Radtke](https://github.com/Trolldemorted) for decompiling and making available a [decompresison script](https://github.com/P3Modding/p3-lib/blob/master/p3-rou/src/lib.rs) for compressed auto route files. This tool exports auto routes in uncompressed format.

### Memory Mapping of Auto Route Files
An auto route can have up to 20 stops, each occupying 220 bytes mapped as follows:

| Offset | Size (bytes)| Description |
| -----: | ----------: | ----------- |
|   0x00 |           2 | Unknown, apparently always `0`, maybe used to keep memory aligned
|   0x02 |           1 | Town id, see [Identifiers of Towns](#identifiers-of-towns)
|   0x03 |           1 | Whether to dock in town (`0x00`), use for repair (`0x01`) or skip (`0x09`); if town is the first of the list, third bit is on (values become `0x04`, `0x05`, `0x0d`)
|   0x04 |        0x18 | Sorting array for the 24 goods, each element being a single byte representing a good id, see [Identifiers and Size of Goods](#identifiers-and-size-of-goods)
|   0x1c |        0x60 | Price array for the 24 goods, each element being a signed 32 bit integer, positive mean selling to the town, negative means buying from the town
|   0x7c |        0x60 | Quantity array for the 24 goods, each element being a signed 32 integer, positive means selling to the town (if price is positive), buying from the town (if price is negative) or withdrawing from the warehouse (if price is `0`), negative means storing into the warehouse (if price is `0`)

### Identifiers of Towns
Towns from the standard map are assigned the following identifiers:

|   ID | Town Name |
| ---: | --------- |
| 0x00 | Edinburgh
| 0x01 | Scarborough
| 0x02 | London
| 0x03 | Burges
| 0x04 | Groningen
| 0x05 | Cologne
| 0x06 | Bremen
| 0x07 | Ripen
| 0x08 | Hamburg
| 0x09 | Luebeck
| 0x0a | Rostock
| 0x0b | Bergen
| 0x0c | Oslo
| 0x0d | Aalborg
| 0x0e | Malmo
| 0x0f | Stockholm
| 0x10 | Visby
| 0x11 | Stettin
| 0x12 | Gdansk
| 0x13 | Torun
| 0x14 | Riga
| 0x15 | Reval
| 0x16 | Ladoga
| 0x17 | Novgorod

### Identifiers and Size of Goods
Goods are assigned the following identifiers and size or weight:

|   ID | Good Name  | Package Type | Size |
| ---: | ---------- | ------------ | ---: |
| 0x00 | Grain      | bundle       | 2000 |
| 0x01 | Meat       | bundle       | 2000 |
| 0x02 | Fish       | bundle       | 2000 |
| 0x03 | Beer       | barrel       |  200 |
| 0x04 | Salt       | barrel       |  200 |
| 0x05 | Honey      | barrel       |  200 |
| 0x06 | Spices     | barrel       |  200 |
| 0x07 | Wine       | barrel       |  200 |
| 0x08 | Cloth      | barrel       |  200 |
| 0x09 | Skins      | barrel       |  200 |
| 0x0a | Oil        | barrel       |  200 |
| 0x0b | Timber     | bundle       | 2000 |
| 0x0c | Iron Goods | barrel       |  200 |
| 0x0d | Leather    | barrel       |  200 |
| 0x0e | Wool       | bundle       | 2000 |
| 0x0f | Pitch      | barrel       |  200 |
| 0x10 | Pig Iron   | bundle       | 2000 |
| 0x11 | Hemp       | bundle       | 2000 |
| 0x12 | Pottery    | barrel       |  200 |
| 0x13 | Bricks     | bundle       | 2000 |
| 0x14 | Sword      | weapon       |   10 |
| 0x15 | Bow        | weapon       |   10 |
| 0x16 | Crossbow   | weapon       |   10 |
| 0x17 | Carbine    | weapon       |   10 |
