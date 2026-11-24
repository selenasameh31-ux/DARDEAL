import 'dart:io';

void main() {
  try {
    print(File('https://example.com/image.jpg').existsSync());
  } catch(e) {
    print('Error: ' + e.toString());
  }
}
