```bash
cd fhir-parser
python3 -m venv venv
source ./venv/bin/activate
pip3 install --upgrade pip
cp -p Default/mappings.py .
cp -p Default/settings.py .
pip3 install -r requirements.txt
python3 generate.py
ls downloads
rm -rf venv
cd ..
cp -rp TestResources /tmp/
cp -rp fhir-parser /tmp/
```

