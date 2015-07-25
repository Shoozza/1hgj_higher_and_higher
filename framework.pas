unit framework;

interface

procedure Load;
procedure Quit;

implementation

uses
  Allegro5,
  al5audio,
  al5acodec,
  al5font,
  al5ttf,
  al5primitives,
  al5image,
  logger,
  globals;

procedure Load;
begin
  ScreenWidth := 480;
  ScreenHeight := 854;

  if not al_init then
    ErrorQuit('Init');

  BackgroundColor := al_map_rgb(11, 11, 11);

  //al_set_new_display_flags(ALLEGRO_NOFRAME);
  al_set_new_display_option(ALLEGRO_VSYNC, 1, ALLEGRO_SUGGEST);

  Display := al_create_display(ScreenWidth, ScreenHeight);
  if Display = nil then
    ErrorQuit('Display');

  al_clear_to_color(BackgroundColor);
  al_flip_display;

  al_set_window_title(Display, 'The Game');

  al_init_image_addon;
  al_install_keyboard;
  al_install_mouse;
  al_install_audio;
  al_init_acodec_addon;
  al_init_font_addon;
  al_init_ttf_addon;
  al_init_primitives_addon;

  al_reserve_samples(16);

  Timer := al_create_timer(1 / FPS);
  if Timer = nil then
    ErrorQuit('Timer');

  Queue := al_create_event_queue;
  if Queue = nil then
    ErrorQuit('Queue');

  al_register_event_source(Queue, al_get_display_event_source(Display));
  al_register_event_source(Queue, al_get_keyboard_event_source);
  al_register_event_source(Queue, al_get_mouse_event_source);
  al_register_event_source(Queue, al_get_timer_event_source(Timer));

  al_start_timer(Timer);
end;

procedure Quit;
begin
end;

end.
