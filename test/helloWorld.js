const HelloWorld = artifacts.require("HelloWorld");

// Le bloc 'contract' définit une suite de tests pour le contrat "HelloWorld"
contract("HelloWorld" , () => {
    // Le bloc 'it' définit un test spécifique
    it("Hello World Testing" , async () => {
        // 1. Déploiement/Récupération de l'instance du contrat déployé
        const helloWorld = await HelloWorld.deployed(); 
        
        // 2. Exécution de la fonction qui modifie l'état (transaction)
        await helloWorld.setName("User Name"); 
        
        // 3. Appel de la fonction getter pour lire l'état (call)
        const result = await helloWorld.yourName(); 
        
        // 4. Assertion : vérifie si le résultat correspond à ce qui a été défini
        assert(result === "User Name"); 
    });
});