//
//  ViewController.swift
//  Project10
//
//  Created by Mehmet Can Şimşek on 28.06.2022.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Names to Faces "
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }

     @objc func addNewPerson() {
        let picer = UIImagePickerController()
        let camera = UIImagePickerController.isSourceTypeAvailable(.camera)
         if camera {
             picer.sourceType = .camera
         }else {
             picer.sourceType = .photoLibrary
         }
        picer.allowsEditing = true
        picer.delegate = self
        present(picer, animated: true)
    }
    
   /* func picerChouse(picer: UIImagePickerController, isCamera: Bool) {
        if isCamera {
            picer.sourceType = .camera
        }else {
            picer.sourceType = .photoLibrary
        }
        picer.allowsEditing = true
        picer.delegate = self
        self.present(picer, animated: true)
    }
    
    
    @objc func addNewPerson() {
        let Camera = UIImagePickerController.isSourceTypeAvailable(.camera)
        if Camera {
            let ac = UIAlertController(title: "What do you want to use? ", message: nil, preferredStyle: .actionSheet)
            ac.addAction((UIAlertAction(title: "Camera", style: .default, handler: { _ in
                let picer = UIImagePickerController()
                self.picerChouse(picer: picer, isCamera: true)
            })))
            ac.addAction(UIAlertAction(title: "Library", style: .default, handler: { _ in
                let picer = UIImagePickerController()
                self.picerChouse(picer: picer, isCamera: false)
            }))
            present(ac, animated: true)
        }
        
    }*/
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath ) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        
        cell.nameLbl.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 7
        
        
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
            
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let alert = UIAlertController(title: "What do you want to do?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [weak self] _ in
            self?.deletePerson(person: person, index: indexPath)
        }))
        alert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { [weak self] _ in
            self?.renameText(person: person)
        }))
       present(alert, animated: true)
    }
    
    
    @objc func deletePerson(person: Person, index: IndexPath) {
        people.remove(at: index.item)
        collectionView.reloadData()
    }
    
    
    @objc func renameText(person: Person) {
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            
            self?.collectionView.reloadData()
        }))
        
        present(ac, animated: true)
    }

}

