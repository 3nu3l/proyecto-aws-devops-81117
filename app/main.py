import os

from flask import Flask, jsonify, request

def create_app():
    app = Flask(__name__)

    env_type = os.getenv("ENV_TYPE", "not_set")
    db_password = os.getenv("DB_PASSWORD", "not_set")

    orders = [
        {"id": 1, "item": "Libro", "quantity": 1},
        {"id": 2, "item": "Teclado mecánico", "quantity": 2},
    ]

    @app.route("/health", methods=["GET"])
    def health():
        return (
            jsonify(
                {
                    "status": "ok",
                    "env_type": env_type,
                    "db_password_configured": db_password != "not_set",
                }
            ),
            200,
        )

    @app.route("/orders", methods=["GET"])
    def list_orders():
        return jsonify(orders), 200

    @app.route("/orders", methods=["POST"])
    def create_order():
        data = request.json or {}
        new_id = max(o["id"] for o in orders) + 1 if orders else 1
        order = {
            "id": new_id,
            "item": data.get("item", "unknown"),
            "quantity": data.get("quantity", 1),
        }
        orders.append(order)
        return jsonify(order), 201

    return app

if __name__ == "__main__":
    app = create_app()
    app.run(host="0.0.0.0", port=8000)