<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">

</script>

<html>
<head>
    <title>GYM Activity Logger</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">

    <!-- Optional theme -->
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h3 class="text-muted">GYM Activity Logger</h3>
            <hr />
        </div>

        <div class="row marketing">
            <div class="alert alert-success alert-dismissable">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                Updated successfully.
            </div>
            <div class="alert alert-danger alert-dismissable">
                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                Updated unsuccessfully.
            </div>

            <div class="col-lg-12">
                <select class="form-control">
                    <option>Cardio Not Performed</option>
                    <option>Cardio Performed</option>
                    <option>Swim</option>
                </select>

                <div class="checkbox">
                    <label>
                        <input type="checkbox" value="">
                        Non-Cardio (Weight)
                    </label>
                </div>

                <div class="checkbox">
                    <label>
                        <input type="checkbox" value="">
                        Fizzy Drinks
                    </label>
                </div>

                <div class="checkbox">
                    <label>
                        <input type="checkbox" value="">
                        High Fibre & Protein
                    </label>
                </div>

                <div class="checkbox">
                    <label>
                        <input type="checkbox" value="">
                        Junk Food
                    </label>
                </div>

                <div class="input-group">
                    <span class="input-group-addon">
                        <input type="checkbox">
                    </span>
                    <input type="text" class="form-control" placeholder="Extra Information">
                </div>
                <!-- /input-group -->
                <br />
                <button type="button" class="btn btn-primary btn-lg btn-block">Submit</button>
            </div>

        </div>

        <div class="footer">
            <hr />
            <p>&copy; Leon Yu Zhao 2014</p>
        </div>
    </div>

    <!-- Placed at the end of the document so the pages load faster -->
    <script src="http://cdn.bootcss.com/jquery/1.10.2/jquery.min.js"></script>
    <!-- Latest compiled and minified JavaScript -->
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
</body>
</html>
