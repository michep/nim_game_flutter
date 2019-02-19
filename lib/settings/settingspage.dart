import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../state/gamebloc.dart';
import '../game/nimgame.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  NIMGameSettings _settings;

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: StreamBuilder(
        stream: GlobalBloc.settingsstream,
        builder: (BuildContext context, AsyncSnapshot<NIMGameSettings> settingsData) {
          if (settingsData.hasData) {
            return FormBuilder(
              context,
              onChanged: (values) => print("onChange: $values"),
              // onSubmit: (Map<String, dynamic> values) => _commitSettings(context, values),
              onSubmit: _commitSettings(context),
              controls: [
                FormBuilderInput.dropdown(
                  label: "Game Type",
                  attribute: "type",
                  value: settingsData.data.gameType,
                  options: [
                    FormBuilderInputOption(value: NIMGameType.pvp, label: "PvP"),
                    FormBuilderInputOption(value: NIMGameType.pvc, label: "PvC"),
                  ],
                ),
                FormBuilderInput.dropdown(
                  label: "Game Difficulty",
                  attribute: "difficulty",
                  value: settingsData.data.difficulty,
                  options: [
                    FormBuilderInputOption(value: NIMDifficulty.easy, label: "Easy"),
                    FormBuilderInputOption(value: NIMDifficulty.hard, label: "Hard"),
                    FormBuilderInputOption(value: NIMDifficulty.insane, label: "Insane"),
                  ],
                ),
                FormBuilderInput.dropdown(
                  label: "Misere Game",
                  attribute: "misere",
                  value: settingsData.data.misere,
                  options: [
                    FormBuilderInputOption(value: false, label: "No"),
                    FormBuilderInputOption(value: true, label: "Yes"),
                  ],
                ),
              ],
            );
          } else {
            return Center(
              child: Text("Loading..."),
            );
          }
        },
      ),
    );
  }

  _commitSettings(BuildContext context) {
    return (values) {
      GlobalBloc.push(NIMNewSettingsEvent(NIMGameSettings(
          gameType: values["type"],
          firstTurn: NIMPlayer.player1,
          difficulty: values["difficulty"],
          misere: values["misere"],
          playerName1: "PLAYER 1",
          playerName2: "PLAYER 2",
          initPiles: [3, 5, 7])));
      Navigator.pop(context);
    };
  }
}
