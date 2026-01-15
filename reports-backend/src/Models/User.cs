namespace reports_backend.Models
{

    public enum UserPosition
    {
        BasicUser, // 0
        Admin // 1
    }
    public class User
    {
        public int Id { get; set; }
        public string Email { get; set; }
        public string Name { get; set; }
        public int Age { get; set; }
        public UserPosition Position { get; set; } //Puesto
        public string PasswordHash { get; set; }
    }
}
