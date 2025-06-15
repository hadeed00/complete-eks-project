from flask import Flask, jsonify, request

app = Flask(__name__)

# In-memory storage
todos = []

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify(status='ok'), 200

@app.route('/todos', methods=['GET'])
def get_todos():
    return jsonify(todos)

@app.route('/todos', methods=['POST'])
def add_todo():
    data = request.get_json()
    if not data or 'task' not in data:
        return jsonify(error="Missing 'task'"), 400
    todos.append({'id': len(todos) + 1, 'task': data['task']})
    return jsonify(message='Todo added'), 201

@app.route('/todos/<int:todo_id>', methods=['DELETE'])
def delete_todo(todo_id):
    global todos
    todos = [t for t in todos if t['id'] != todo_id]
    return jsonify(message='Todo deleted'), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
