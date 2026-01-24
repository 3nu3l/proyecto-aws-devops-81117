import json
from app.main import create_app

def test_health():
    app = create_app()
    client = app.test_client()
    resp = client.get("/health")
    assert resp.status_code == 200

def test_list_orders():
    app = create_app()
    client = app.test_client()
    resp = client.get("/orders")
    assert resp.status_code == 200


def test_health_unit():
    app = create_app()
    with app.test_request_context("/health"):
        resp, status = app.view_functions["health"]()
    assert status == 200
    assert resp.json == {"status": "ok"}


def test_list_orders_unit():
    app = create_app()
    with app.test_request_context("/orders"):
        resp, status = app.view_functions["list_orders"]()
    assert status == 200
    data = resp.get_json()
    assert isinstance(data, list)
    assert len(data) == 2