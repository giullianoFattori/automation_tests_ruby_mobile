class ConfigPageScreen < BaseScreen
    identificator(:btnGaveta)            {[:accessibility_id, 'Abrir gaveta']}
    identificator(:btnConfig)            {'com.ichi2.anki:id/nav_settings'}
    identificator(:btnAvacado)            {[:xpath, '//android.widget.TextView[@resource-id="android:id/title" and @text="Avançado"]']}
end
  