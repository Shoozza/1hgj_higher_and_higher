unit globals;

interface

uses
  Allegro5,
  al5font,
  al5audio;

const
  FPS = 60;
var
  ScreenWidth, ScreenHeight: Integer;
  Display: ALLEGRO_DISPLAYptr;
  Queue: ALLEGRO_EVENT_QUEUEptr;
  Timer: ALLEGRO_TIMERptr;
  IsRunning: Boolean;
  BackgroundColor: ALLEGRO_COLOR;
  Font: ALLEGRO_FONTptr;
  PlayerImg, StarImg, ZombieImg, Image: ALLEGRO_BITMAPptr;
  Sound: ALLEGRO_SAMPLEptr;
  Music: ALLEGRO_AUDIO_STREAMptr;

implementation

end.
