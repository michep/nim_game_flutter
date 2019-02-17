abstract class NIMGameEvent {}

class NIMTapOnItemEvent extends NIMGameEvent {
  final int pile, item;
  NIMTapOnItemEvent(this.pile, this.item);
}

class NIMEndTurnEvent extends NIMGameEvent {}
