part of email_password_sign_in_ui;

class EmailPasswordSignInPage extends StatefulWidget {
  const EmailPasswordSignInPage(
      {Key? key, required this.model, this.onSignedIn})
      : super(key: key);
  final EmailPasswordSignInModel model;
  final VoidCallback? onSignedIn;

  factory EmailPasswordSignInPage.withFirebaseAuth(FirebaseAuth firebaseAuth,
      {VoidCallback? onSignedIn}) {
    return EmailPasswordSignInPage(
      model: EmailPasswordSignInModel(firebaseAuth: firebaseAuth),
      onSignedIn: onSignedIn,
    );
  }


  @override
  _EmailPasswordSignInPageState createState() =>
      _EmailPasswordSignInPageState();
}

class _EmailPasswordSignInPageState extends State<EmailPasswordSignInPage> {
  final FocusScopeNode _node = FocusScopeNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  EmailPasswordSignInModel get model => widget.model;

  @override
  void initState() {
    super.initState();
    // Temporary workaround to update state until a replacement for ChangeNotifierProvider is found
    model.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    model.dispose();
    _node.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSignInError(EmailPasswordSignInModel model, dynamic exception) {
    showExceptionAlertDialog(
      context: context,
      title: model.errorAlertTitle,
      exception: exception,
    );
  }
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  Future<void> userSetup(String name ) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser?.uid)
        .set({'user': name});
    // CollectionReference users = FirebaseFirestore.instance.collection("users");
    // FirebaseAuth auth = FirebaseAuth.instance;
    // String? uid = auth.currentUser?.uid;
    // users.add({
    //   "user": name,
    //   "uid": uid,
    //
    // });
    // return;
  }




  Future<void> _submit() async {
    try {
      final bool success = await model.submit();
      if (success) {
        if (model.formType == EmailPasswordSignInFormType.forgotPassword) {
          await showAlertDialog(
            context: context,
            title: EmailPasswordSignInStrings.resetLinkSentTitle,
            content: EmailPasswordSignInStrings.resetLinkSentMessage,
            defaultActionText: EmailPasswordSignInStrings.ok,
          );
        } else {
          if (widget.onSignedIn != null) {
            widget.onSignedIn?.call();
          }
        }
      }
    } catch (e) {
      _showSignInError(model, e);
    }
    userSetup(_nameController.text);
  }

  void _nameEditingComplete() {
    if (model.canSubmitEmail) {
      _node.nextFocus();
    }
  }

  void _emailEditingComplete() {
    if (model.canSubmitEmail) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!model.canSubmitEmail) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  void _updateFormType(EmailPasswordSignInFormType formType) {
    model.updateFormType(formType);
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }


  Widget _buildNameField() {
    return TextFormField(
      key: const Key('Name'),
      controller: _nameController,
      decoration: InputDecoration(
        labelText: EmailPasswordSignInStrings.nameLabel,
        hintText: EmailPasswordSignInStrings.nameHint,
        errorText: model.nameErrorText,
        enabled: !model.isLoading,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      keyboardAppearance: Brightness.light,
      onEditingComplete: _nameEditingComplete,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      key: const Key('email'),
      controller: _emailController,
      decoration: InputDecoration(
        labelText: EmailPasswordSignInStrings.emailLabel,
        hintText: EmailPasswordSignInStrings.emailHint,
        errorText: model.emailErrorText,
        enabled: !model.isLoading,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      keyboardAppearance: Brightness.light,
      onEditingComplete: _emailEditingComplete,
      inputFormatters: <TextInputFormatter>[
        model.emailInputFormatter,
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      key: const Key('password'),
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: model.passwordLabelText,
        errorText: model.passwordErrorText,
        enabled: !model.isLoading,
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      keyboardAppearance: Brightness.light,
      onEditingComplete: _passwordEditingComplete,
    );
  }

  Widget _buildContent() {
    return FocusScope(
      node: _node,
      child: Form(
        onChanged: () => model.updateWith(
            email: _emailController.text, password: _passwordController.text),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 6.0),
            if (model.formType != EmailPasswordSignInFormType.forgotPassword &&
                model.formType !=
                    EmailPasswordSignInFormType.signIn) ...<Widget>[
              _buildNameField(),
            ],
            _buildEmailField(),
            if (model.formType !=
                EmailPasswordSignInFormType.forgotPassword) ...<Widget>[
              const SizedBox(height: 6.0),
              _buildPasswordField(),
            ],
            const SizedBox(height: 6.0),
            FormSubmitButton(
              key: const Key('primary-button'),
              text: model.primaryButtonText,
              loading: model.isLoading,
              onPressed: model.isLoading ? null : _submit,


            ),
            const SizedBox(height: 6.0),
            FlatButton(
                key: const Key('secondary-button'),
                child: Text(model.secondaryButtonText),
                onPressed: model.isLoading
                    ? null
                    : () => _updateFormType(model.secondaryActionFormType),
                color: Colors.white,
            ),
            if (model.formType == EmailPasswordSignInFormType.signIn)
              FlatButton(
                key: const Key('tertiary-button'),
                child: const Text(
                    EmailPasswordSignInStrings.forgotPasswordQuestion),
                onPressed: model.isLoading
                    ? null
                    : () => _updateFormType(
                    EmailPasswordSignInFormType.forgotPassword),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/womans-hands-with-paper-man-family-38561884.jpg',
            ),
            Center(
              child: LayoutBuilder(builder: (context, constraints) {
                return Container(
                  width: min(constraints.maxWidth, 600),
                  padding: const EdgeInsets.all(16.0),
                  // child: Card(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(16.0),
                  child: _buildContent(),
                  //   ),
                  // ),
                );
              }),
            ),
            Image.asset(
              'assets/ESP-Logo_draft4.png',
              height: 100,
              width: 200,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }
}
