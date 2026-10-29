from app.config import Config


def test_render_database_url_uses_installed_psycopg_driver(monkeypatch):
    monkeypatch.setenv("DATABASE_URL", "postgresql://reader:secret@db/openlibrary")
    assert Config.from_env().database_url == "postgresql+psycopg://reader:secret@db/openlibrary"
