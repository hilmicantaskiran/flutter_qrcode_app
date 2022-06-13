import 'package:flutter/material.dart';

class DropdownItems {
  static List<DropdownMenuItem<String>> get facultylist {
    List<DropdownMenuItem<String>> faculties = const [
      DropdownMenuItem(child: Text("Mühendislik Fakültesi"), value: "Mühendislik Fakültesi"),
      DropdownMenuItem(child: Text("İktisad Fakültesi"), value: "İktisad Fakültesi"),
      DropdownMenuItem(child: Text("İdari Bilimler Fakültesi"), value: "İdari Bilimler Fakültesi"),
      DropdownMenuItem(child: Text("Tıp Fakültesi"), value: "Tıp Fakültesi"),
      DropdownMenuItem(child: Text("Fen Edebiyat Fakültesi"), value: "Fen Edebiyat Fakültesi"),
      DropdownMenuItem(child: Text("Hemşirelik Fakültesi"), value: "Hemşirelik Fakültesi"),
      DropdownMenuItem(child: Text("Eğitim Fakültesi"), value: "Eğitim Fakültesi"),
      DropdownMenuItem(child: Text("Diş Hekimliği Fakültesi"), value: "Diş Hekimliği Fakültesi"),
      DropdownMenuItem(child: Text("Sağlık Bilimleri Fakültesi"), value: "Sağlık Bilimleri Fakültesi"),
      DropdownMenuItem(child: Text("İletişim Fakültesi"), value: "İletişim Fakültesi"),
      DropdownMenuItem(child: Text("İslami Bilimler Fakültesi"), value: "İslami Bilimler Fakültesi"),
    ];
    return faculties;
  }

  static List<DropdownMenuItem<String>> get departmentlist {
    List<DropdownMenuItem<String>> departments = const [
      DropdownMenuItem(child: Text("Bilgisayar Mühendisliği (İngilizce)"), value: "Bilgisayar Mühendisliği (İngilizce)"),
      DropdownMenuItem(child: Text("Makine Mühendisliği (İngilizce)"), value: "Makine Mühendisliği (İngilizce)"),
      DropdownMenuItem(
          child: Text("Elektrik-Elektronik Mühendisliği (İngilizce)"), value: "Elektrik-Elektronik Mühendisliği (İngilizce)"),
      DropdownMenuItem(child: Text("Endüstri Mühendisliği (İngilizce)"), value: "Endüstri Mühendisliği (İngilizce)"),
      DropdownMenuItem(child: Text("İnşaat Mühendisliği (İngilizce)"), value: "İnşaat Mühendisliği (İngilizce)"),
      DropdownMenuItem(child: Text("Gıda Mühendisliği (İngilizce)"), value: "Gıda Mühendisliği (İngilizce)"),
      DropdownMenuItem(child: Text("Ziraat Mühendisliği"), value: "Ziraat Mühendisliği"),
      DropdownMenuItem(child: Text("Hemşirelik"), value: "Hemşirelik"),
      DropdownMenuItem(child: Text("Felsefe"), value: "Felsefe"),
      DropdownMenuItem(child: Text("Fizik"), value: "Fizik"),
      DropdownMenuItem(child: Text("Kimya"), value: "Kimya"),
      DropdownMenuItem(child: Text("Matematik"), value: "Matematik"),
      DropdownMenuItem(child: Text("Sosyoloji"), value: "Sosyoloji"),
      DropdownMenuItem(child: Text("Tarih"), value: "Tarih"),
    ];
    return departments;
  }
}
