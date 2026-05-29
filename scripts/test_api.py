import json
import urllib.error
import urllib.request


def main():
    url = "http://localhost:18080/request"
    print("Testing Rate Limiter API...\n")

    for i in range(7):
        payload = json.dumps({"user": "test_user"}).encode("utf-8")
        req = urllib.request.Request(
            url,
            data=payload,
            headers={"Content-Type": "application/json"},
            method="POST",
        )

        try:
            with urllib.request.urlopen(req, timeout=5) as response:
                body = response.read().decode("utf-8")
                print(f"Request {i+1}: Status {response.status} - {body}")
        except urllib.error.HTTPError as e:
            body = e.read().decode("utf-8")
            print(f"Request {i+1}: Status {e.code} - {body}")
        except Exception as e:
            print(f"Request {i+1}: Error - {e}")


if __name__ == "__main__":
    main()
