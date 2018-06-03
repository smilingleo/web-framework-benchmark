from flask import Flask, request, jsonify
 
app = Flask(__name__)
 
@app.route('/json-data', methods = ['POST'])
def postJsonHandler():
    content = request.get_json()
    return jsonify(content)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
