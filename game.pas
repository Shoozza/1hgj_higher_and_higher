unit game;

interface

procedure Run;

procedure Load;
procedure Quit;


implementation

uses
  SysUtils,
  Allegro5,
  al5font,
  al5ttf,
  al5primitives,
  al5audio,
  globals,
  logger,
  input;

type
  TPlayer = record
    x, y, vx, vy: Single;
    hit, jet: Integer;
  end;

  TZombie = record
    active: Boolean;
    x, y, vx, vy: Single;
    hp, jet: Integer;
  end;

  TStar = record
    active: Boolean;
    x, y, vy: Single;
  end;

const
  GRAVITY = 9;

var
  Player: TPlayer;
  Zombies: Array [0..10] of TZombie;
  Stars: Array [0..20] of TStar;

procedure RandomStar(I: Integer);
begin
    Stars[I].active := True;
    Stars[I].x := random(ScreenWidth div 20)*20;
    Stars[I].y := -random(ScreenHeight div 2);
end;

procedure RandomZombie(I: Integer);
begin
    Zombies[I].active := True;
    Zombies[I].x := random(ScreenWidth div al_get_bitmap_width(ZombieImg)*2) * al_get_bitmap_width(ZombieImg);
    Zombies[I].y := -random(ScreenHeight div al_get_bitmap_height(ZombieImg)*3) * al_get_bitmap_height(ZombieImg);
end;

procedure Enter;
var
  I: Integer;
begin
  Log('Enter');
  ResetKeys;

  for I := Low(Zombies) to High(Zombies) do
  begin
    RandomZombie(I);
    Zombies[I].vy := 5;
  end;

  for I := Low(Stars) to High(Stars) do
  begin
    RandomStar(I);
    Stars[I].vy := 30;
  end;
end;

procedure Leave;
begin
end;

procedure Load;
begin
  Randomize;
  Font := al_load_ttf_font_stretch('assets' + PathDelim + 'font.ttf', 26, 20,
    ALLEGRO_TTF_MONOCHROME or
    ALLEGRO_TTF_NO_KERNING or
    ALLEGRO_TTF_NO_AUTOHINT or
    0);
  if Font = nil then
    ErrorQuit('Font');

  Image := al_load_bitmap('assets' + PathDelim + 'image.png');
  if Image = nil then
    ErrorQuit('Image');

  StarImg := al_load_bitmap('assets' + PathDelim + 'star.png');
  if StarImg = nil then
    ErrorQuit('Star Image');

  ZombieImg := al_load_bitmap('assets' + PathDelim + 'zombie.png');
  if ZombieImg = nil then
    ErrorQuit('Zombie Image');

  PlayerImg := al_load_bitmap('assets' + PathDelim + 'player.png');
  if PlayerImg = nil then
    ErrorQuit('Player Image');

  //Sound := al_load_sample('assets' + PathDelim + 'sound.wav');
  //if Sound = nil then
    //ErrorQuit('Sound');

  {
  // not yet ready
  Music := al_load_audio_stream('assets' + PathDelim + 'music.ogg', 4, 2048);
  if Music = nil then
    ErrorQuit('Music');

  al_register_event_source(queue, al_get_audio_stream_event_source(Music));
  }

  //al_play_sample(Sound, 1, 0, 1, ALLEGRO_PLAYMODE_ONCE, nil);
end;

procedure Quit;
begin
end;

procedure UpdateStars;
var
  I: Integer;
begin
  for I := Low(Stars) to High(Stars) do
  begin
    Stars[I].y := Stars[I].y + Stars[I].vy;
    if Stars[I].y > ScreenHeight + 20 then
    begin
      RandomStar(I);
    end;
  end;
end;

procedure UpdatePlayer;
var
  I: Integer;
begin
  Player.x := Player.x - Player.vx;
  Player.y := Player.y - Player.vy + GRAVITY;

  if Player.vy > 1 then
    Player.vy := Player.vy - 1;

  if Player.vx > 1 then
    Player.vx := Player.vx - 0.25;

  if Player.x <= 0 then
  begin
    Player.x := 0;
    Player.vx := -Player.vx / 2;
  end;

  if Player.x + al_get_bitmap_width(PlayerImg) >= ScreenWidth then
  begin
    Player.x := ScreenWidth - al_get_bitmap_width(PlayerImg);
    Player.vx := -Player.vx / 2;
  end;

  for I := Low(Zombies) to High(Zombies) do
  begin
    if Zombies[I].active then
    begin
      if ((Player.x + al_get_bitmap_width(PlayerImg) div 2)  > Zombies[I].x) and
         ((Player.x + al_get_bitmap_width(PlayerImg) div 2)  < (Zombies[I].x + al_get_bitmap_width(ZombieImg))) and
         ((Player.y + al_get_bitmap_height(PlayerImg) div 2) > Zombies[I].y) and
         ((Player.y + al_get_bitmap_height(PlayerImg) div 2) < (Zombies[I].y + al_get_bitmap_height(ZombieImg))) then
         Player.hit := 60;
   end;
  end;
end;

procedure UpdateZombies;
var
  I: Integer;
begin
  for I := Low(Zombies) to High(Zombies) do
  begin
    if Zombies[I].active then
    begin
      Zombies[I].x := Zombies[I].x - Zombies[I].vx;
      Zombies[I].y := Zombies[I].y - Zombies[I].vy + GRAVITY;
      if Zombies[I].y > ScreenHeight + 120 then
      begin
        RandomZombie(I);
      end;
    end;
  end;
end;

procedure Draw;
var
  I: Integer;
begin
  al_clear_to_color(BackgroundColor);

  for I := Low(Stars) to High(Stars) do
  begin
    if Stars[I].active then
      al_draw_bitmap(StarImg, Stars[I].x, Stars[I].y, 0);
  end;

  al_draw_bitmap(Image, 0, 40, 0);

  if Player.hit = 0 then
    al_draw_bitmap(PlayerImg, Player.x, Player.y, 0)
  else
  begin
    if (Player.Hit mod 4 = 0) or (((Player.hit + 1) mod 4) = 0) then
      al_draw_bitmap(ZombieImg, Player.x, Player.y, 0)
    else
      al_draw_bitmap(PlayerImg, Player.x, Player.y, 0);
    Player.hit := Player.hit - 1;
  end;

  for I := Low(Zombies) to High(Zombies) do
  begin
    if Zombies[I].active then
      al_draw_bitmap(ZombieImg, Zombies[I].x, Zombies[I].y, 0);
  end;

  al_draw_text(Font, al_map_rgb(0, 0, 0),
    11.0, 11.0, ALLEGRO_ALIGN_LEFT, 'The Game');
  al_draw_text(Font, al_map_rgb(113, 249, 129),
    10.0, 10.0, ALLEGRO_ALIGN_LEFT, 'The Game');

  al_flip_display;
end;

procedure HandleInput;
begin
  if IsKeyJustDown(ALLEGRO_KEY_ESCAPE) then
    IsRunning := False;

  if IsKeyJustDown(ALLEGRO_KEY_W) then
    Player.vy := 28;

  if IsKeyJustDown(ALLEGRO_KEY_A) then
    Player.vx := 8;

  if IsKeyJustDown(ALLEGRO_KEY_D) then
    Player.vx := -8;

  RefreshKeys;
end;

procedure Update;
begin
  HandleInput;

  UpdateStars;
  UpdatePlayer;
  UpdateZombies;
end;

procedure Run;
var
  NeedsRedraw: Boolean;
  Event: ALLEGRO_EVENT;
begin
  Enter;

  NeedsRedraw := True;
  IsRunning := True;

  while IsRunning do
  begin
    al_wait_for_event(Queue, Event);

    case Event._Type of
      ALLEGRO_EVENT_TIMER:
      begin
        NeedsRedraw := True;
      end;

      ALLEGRO_EVENT_DISPLAY_CLOSE:
      begin
        IsRunning := False;
      end;

      ALLEGRO_EVENT_KEY_DOWN:
      begin
        RefreshKeyDown(Event.keyboard.keycode);
      end;

      ALLEGRO_EVENT_KEY_UP:
      begin
        RefreshKeyUp(Event.keyboard.keycode);
      end;

      ALLEGRO_EVENT_MOUSE_BUTTON_DOWN:
      begin
      end;

      ALLEGRO_EVENT_MOUSE_BUTTON_UP:
      begin
      end;

    end;

    if NeedsRedraw and al_is_event_queue_empty(Queue) then
    begin
      NeedsRedraw := False;
      Update;
      Draw;
    end;
  end;
  Leave;
end;


end.
