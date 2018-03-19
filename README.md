![sjls-demo](sjls-demo.gif "sjLS Demo")

### Usage

To bring up the user interface enter `/sjls show`. The top edit box is the Link Preview area, and the bottom edit box is the Link Raw area. Basically any time the raw content is changed the preview content is updated to display what the link would look like in game. To get started:

1. Click within Link Preview and link and item you want to use as a base (shift-click)
2. Edit the raw link
3. Click the Print button to output the spoof link to the main chat frame

### Link Format

Links in WoW are formatted as such: `|c<COLOR>|Hitem<ITEMCODE>[:ITEMMOD]||h<DISPLAYTEXT>|h|r`

- `<COLOR>` is the Hex representation for the link. For example, the default uncommon color (green item) is `ff1eff00` where the first `ff` is the alpha value (unused) and `1eff00` is the Hex RGB.
- `<ITEMCODE>` is the item code or index of the item to show in the toolsip. Just look up the item in a Vanilla database and the code should be in the URL query string. For example, [Benediction](https://classicdb.ch/?item=18608) is item 18608 as seen in URL.
- `[:ITEMMOD]` is an *optional* series of parameters for adding certain modifiers to the item tooltip. I don't quite understand what adds what, but with it you can set enchants, random rolls, etc.
- `<DISPLAYTEXT>` The text to display for the link in the chat frame.
