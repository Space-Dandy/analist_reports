// using NUnit.Framework;
// using Moq;
// using System.Collections.Generic;
// using System.Linq;
// using reports_backend.Models;
// using reports_backend.Services;
// using reports_backend.Data;
// using reports_backend.Controllers;

// namespace reports_backend.tests
// {
//     [TestFixture]
//     public class UnitTests
//     {
//         private Mock<IService> _serviceMock;
//         private ApiController _apiController;

//         [SetUp]
//         public void Setup()
//         {
//             _serviceMock = new Mock<IService>();
//             _apiController = new ApiController(_serviceMock.Object);
//         }

//         [Test]
//         public void GetItems_ReturnsAllItems()
//         {
//             // Arrange
//             var items = new List<Model>
//             {
//                 new Model { Id = 1, Name = "Item1" },
//                 new Model { Id = 2, Name = "Item2" }
//             };
//             _serviceMock.Setup(s => s.GetAllItems()).Returns(items);

//             // Act
//             var result = _apiController.GetItems();

//             // Assert
//             Assert.AreEqual(2, result.Count());
//         }

//         [Test]
//         public void PostItem_AddsItem()
//         {
//             // Arrange
//             var newItem = new Model { Id = 3, Name = "Item3" };
//             _serviceMock.Setup(s => s.AddItem(newItem)).Verifiable();

//             // Act
//             _apiController.PostItem(newItem);

//             // Assert
//             _serviceMock.Verify(s => s.AddItem(newItem), Times.Once);
//         }

//         [Test]
//         public void Repository_GetAllItems_ReturnsAllItems()
//         {
//             // Arrange
//             var repository = new Repository();
//             repository.AddItem(new Model { Id = 1, Name = "Item1" });
//             repository.AddItem(new Model { Id = 2, Name = "Item2" });

//             // Act
//             var items = repository.GetAllItems();

//             // Assert
//             Assert.AreEqual(2, items.Count());
//         }

//         [Test]
//         public void Repository_AddItem_AddsItem()
//         {
//             // Arrange
//             var repository = new Repository();
//             var newItem = new Model { Id = 3, Name = "Item3" };

//             // Act
//             repository.AddItem(newItem);
//             var items = repository.GetAllItems();

//             // Assert
//             Assert.AreEqual(1, items.Count());
//             Assert.AreEqual("Item3", items.First().Name);
//         }
//     }
// }