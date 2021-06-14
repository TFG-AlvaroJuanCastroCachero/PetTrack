class Usuario {
  String email, nombre;

  Usuario(this.nombre, this.email);

  // Usuario.fromSnapshot(DataSnapshot snapshot)
  //     : nombre = snapshot.value["nombre"],
  //       email = snapshot.value["email"],
  //       usuario = snapshot.value["usuario"];

  // toJson() {
  //   return {
  //     "nombre": nombre,
  //     "email": email,
  //     "usuario": usuario,
  //   };
  // }
}
