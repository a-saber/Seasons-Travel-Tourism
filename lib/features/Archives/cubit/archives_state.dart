
abstract class ArchivesState {}

class ArchivesInitial extends ArchivesState {}

class ArchivesChangeInitial extends ArchivesState {}
class ArchivesLoadingInitial extends ArchivesState {}
class ArchivesSuccessInitial extends ArchivesState {}
class ArchivesErrorInitial extends ArchivesState
{
  String error;
  ArchivesErrorInitial(this.error);
}
